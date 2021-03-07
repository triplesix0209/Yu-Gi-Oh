-- Mausoleum of the Signer Dragons
Duel.LoadScript("util.lua")
local s, id = GetID()

s.listed_names = {410000505}
s.listed_series = {0xc2, 0x3f}

function s.deck_edit(tp)
    -- Stardust Dragon
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EXTRA, 0, 1, nil,
                                   44508094, 83994433) then
        Duel.SendtoDeck(Duel.CreateToken(tp, 7841112), tp, 2, REASON_RULE)
    end

    -- Red Dragon Archfiend
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EXTRA, 0, 1, nil,
                                   70902743, 39765958, 80666118) then
        Duel.SendtoDeck(Duel.CreateToken(tp, 67030233), tp, 2, REASON_RULE)
    end

    -- Black-Winged Dragon
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EXTRA, 0, 1, nil,
                                   9012916, 60992105) then
        Duel.SendtoDeck(Duel.CreateToken(tp, 410000501), tp, 2, REASON_RULE)
    end

    -- Black Rose Dragon
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EXTRA, 0, 1, nil,
                                   73580471, 33698022) then
        Duel.SendtoDeck(Duel.CreateToken(tp, 410000502), tp, 2, REASON_RULE)
    end

    -- Ancient Fairy Dragon
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EXTRA, 0, 1, nil,
                                   25862681, 4179255) then
        Duel.SendtoDeck(Duel.CreateToken(tp, 410000503), tp, 2, REASON_RULE)
    end

    -- Power Tool Dragon
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EXTRA, 0, 1, nil,
                                   2403771, 68084557) then
        Duel.SendtoDeck(Duel.CreateToken(tp, 410000504), tp, 2, REASON_RULE)
    end

    -- Shooting Star Dragon
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EXTRA, 0, 1, nil,
                                   24696097) then
        Duel.SendtoDeck(Duel.CreateToken(tp, 101105104), tp, 2, REASON_RULE)
        Duel.SendtoDeck(Duel.CreateToken(tp, 68431965), tp, 2, REASON_RULE)
    end

    -- Shooting Quasar Dragon
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EXTRA, 0, 1, nil,
                                   35952884) then
        Duel.SendtoDeck(Duel.CreateToken(tp, 26268488), tp, 2, REASON_RULE)
        Duel.SendtoDeck(Duel.CreateToken(tp, 21123811), tp, 2, REASON_RULE)
    end
end

function s.global_effect(c, tp)
    -- Stardust Dragon
    local eg1 = Effect.CreateEffect(c)
    eg1:SetType(EFFECT_TYPE_SINGLE)
    eg1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    eg1:SetCode(EFFECT_ADD_CODE)
    eg1:SetValue(CARD_STARDUST_DRAGON)
    Utility.RegisterGlobalEffect(c, eg1, Card.IsCode, 83994433)

    -- Red Dragon Archfiend
    local eg2 = eg1:Clone()
    eg2:SetValue(70902743)
    Utility.RegisterGlobalEffect(c, eg2, Card.IsCode, 39765958)
    Utility.RegisterGlobalEffect(c, eg2, Card.IsCode, 80666118)

    -- Black-Winged Dragon
    local eg3 = eg1:Clone()
    eg3:SetValue(9012916)
    Utility.RegisterGlobalEffect(c, eg3, Card.IsCode, 60992105)

    -- Black Rose Dragon
    local eg4 = eg1:Clone()
    eg4:SetValue(73580471)
    Utility.RegisterGlobalEffect(c, eg4, Card.IsCode, 33698022)

    -- Ancient Fairy Dragon
    local eg5 = eg1:Clone()
    eg5:SetValue(25862681)
    Utility.RegisterGlobalEffect(c, eg5, Card.IsCode, 4179255)

    -- Power Tool Dragon
    local eg6 = eg1:Clone()
    eg6:SetValue(2403771)
    Utility.RegisterGlobalEffect(c, eg6, Card.IsCode, 68084557)
end

function s.initial_effect(c)
    -- activate
    local act = Effect.CreateEffect(c)
    act:SetType(EFFECT_TYPE_ACTIVATE)
    act:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(act)

    -- search
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCondition(s.e1con)
    e1:SetTarget(s.e1tg)
    e1:SetOperation(s.e1op)
    c:RegisterEffect(e1)

    -- cannot disable summon
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE + EFFECT_FLAG_SET_AVAILABLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(1, 0)
    e2:SetTarget(function(e, c)
        if not c:IsType(TYPE_SYNCHRO) then return false end
        return (c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON)) or
                   c:IsSetCard(0xc2)
    end)
    c:RegisterEffect(e2)

    -- cannot to extra
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TO_DECK)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE, 0)
    e3:SetTarget(function(e, c)
        return c:IsType(TYPE_EXTRA) and c:IsType(TYPE_SYNCHRO) and
                   c:IsSetCard(0x3f)
    end)
    e3:SetValue(1)
    c:RegisterEffect(e3)

    -- additional summon
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 1))
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_HAND + LOCATION_MZONE, 0)
    e4:SetTarget(function(e, c) return c:IsType(TYPE_TUNER) end)
    c:RegisterEffect(e4)

    -- draw
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(1108)
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCondition(s.e5con)
    e5:SetTarget(s.e5tg)
    e5:SetOperation(s.e5op)
    c:RegisterEffect(e5)

    -- when dragon leaves
    local e6 = Effect.CreateEffect(c)
    e6:SetDescription(7)
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetRange(LOCATION_FZONE)
    e6:SetCondition(s.e6con)
    e6:SetTarget(s.e6tg)
    e6:SetOperation(s.e6op)
    c:RegisterEffect(e6)
end

function s.e1filter(c) return c:IsCode(410000505) and c:IsAbleToHand() end

function s.e1con(e, tp, eg, ep, ev, re, r, rp)
    return tp == Duel.GetTurnPlayer() and
               Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0 and
               Duel.GetDrawCount(tp) > 0
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.e1filter, tp,
                                           LOCATION_DECK + LOCATION_GRAVE, 0, 1,
                                           nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0,
                          LOCATION_DECK + LOCATION_GRAVE)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()

    local dt = Duel.GetDrawCount(tp)
    if dt == 0 then return false end
    _replace_count = 1
    _replace_max = dt

    local ec1 = Effect.CreateEffect(c)
    ec1:SetType(EFFECT_TYPE_FIELD)
    ec1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    ec1:SetCode(EFFECT_DRAW_COUNT)
    ec1:SetTargetRange(1, 0)
    ec1:SetValue(0)
    ec1:SetReset(RESET_PHASE + PHASE_DRAW)
    Duel.RegisterEffect(ec1, tp)

    if _replace_count > _replace_max or not c:IsRelateToEffect(e) then return end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.GetMatchingGroup(s.e1filter, tp,
                                    LOCATION_DECK + LOCATION_GRAVE, 0, nil)
    if #g > 1 then g = g:Select(tp, 1, 1) end
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

function s.e5filter(c)
    if not c:IsType(TYPE_SYNCHRO) then return false end
    return (c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON)) or c:IsSetCard(0xc2)
end

function s.e5con(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.e5filter, 1, nil)
end

function s.e5tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp, 1) end

    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.e5op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end

    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER,
                                   CHAININFO_TARGET_PARAM)
    Duel.Draw(p, d, REASON_EFFECT)
end

function s.e6confilter(c, r, rp, tp)
    return c:IsPreviousPosition(POS_FACEUP) and c:IsType(TYPE_SYNCHRO) and
               ((c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON)) or
                   c:IsSetCard(0xc2)) and rp == tp and
               ((r & REASON_EFFECT) == REASON_EFFECT or (r & REASON_COST) ==
                   REASON_COST)
end

function s.e6spfilter(c, e, tp)
    return c:IsFaceup() and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e6con(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.e6confilter, 1, nil, r, rp, tp)
end

function s.e6tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return s.e6sptg(e, tp, eg, ep, ev, re, r, rp) or
                   s.e6dmgtg(e, tp, eg, ep, ev, re, r, rp)
    end
end

function s.e6sptg(e, tp, eg, ep, ev, re, r, rp)
    return eg:Filter(s.e6confilter, nil, r, rp, tp):IsExists(s.e6spfilter, 1,
                                                             nil, e, tp) and
               Duel.GetFlagEffect(tp, id + 1 * 1000000) == 0
end

function s.e6dmgtg(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFlagEffect(tp, id + 2 * 1000000) == 0
end

function s.e6op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end

    local spcheck = s.e6sptg(e, tp, eg, ep, ev, re, r, rp) and
                        Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
    local dmgcheck = s.e6dmgtg(e, tp, eg, ep, ev, re, r, rp)

    local op = 0
    if spcheck and dmgcheck then
        op = Duel.SelectOption(tp, 509, aux.Stringid(id, 2))
    elseif spcheck then
        op = Duel.SelectOption(tp, 509)
    else
        op = Duel.SelectOption(tp, aux.Stringid(id, 2)) + 1
    end

    if op == 0 then
        Duel.RegisterFlagEffect(tp, id + 1 * 1000000, RESET_PHASE + PHASE_END,
                                0, 1)

        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g = eg:Filter(s.e6confilter, nil, r, rp, tp)
        local tc = g:FilterSelect(tp, s.e6spfilter, 1, 1, nil, e, tp)
        Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
    else
        Duel.RegisterFlagEffect(tp, id + 2 * 1000000, RESET_PHASE + PHASE_END,
                                0, 1)
        aux.RegisterClientHint(c, nil, tp, 1, 0, aux.Stringid(id, 1), nil)

        local ec1 = Effect.CreateEffect(c)
        ec1:SetType(EFFECT_TYPE_FIELD)
        ec1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        ec1:SetCode(EFFECT_CHANGE_DAMAGE)
        ec1:SetTargetRange(1, 0)
        ec1:SetValue(s.e6dmgval)
        ec1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(ec1, tp)
    end
end

function s.e6dmgval(e, re, ev, r, rp, rc) return math.floor(ev / 2) end