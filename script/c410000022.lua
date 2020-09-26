-- Palladium Sacred Guardian
local s, id = GetID()

function s.initial_effect(c)
    c:EnableReviveLimit()

    -- xyz summon
    Xyz.AddProcedure(c, nil, 7, 3, nil, nil, 3, nil, false, s.xyzcheck)

    -- lock zones
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.e1con)
    e1:SetTarget(s.e1tg)
    e1:SetOperation(s.e1op)
    c:RegisterEffect(e1)

    -- immune
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.e2con)
    e2:SetValue(s.e2val)
    c:RegisterEffect(e2)

    -- damage reduce
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(1, 0)
    e3:SetValue(function(e, re, val, r, rp, rc)
        if r & REASON_EFFECT ~= 0 then return 0 end
        return val
    end)
    c:RegisterEffect(e3)
    local e3b = e3:Clone()
    e3b:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    c:RegisterEffect(e3b)

    -- destroy replace
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(s.e4tg)
    c:RegisterEffect(e4)
end

function s.xyzcheck(g, tp, sc) return g:GetClassCount(Card.GetAttribute) == #g end

function s.e1con(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(1 - tp, LOCATION_MZONE) > 0 end
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()

    local ct = Duel.GetLocationCount(1 - tp, LOCATION_MZONE)
    if ct == 0 then return end
    if ct > 3 then ct = 3 end

    local zones = Duel.SelectDisableField(tp, ct, 0, LOCATION_MZONE, 0)
    local ec1 = Effect.CreateEffect(c)
    ec1:SetType(EFFECT_TYPE_FIELD)
    ec1:SetCode(EFFECT_DISABLE_FIELD)
    ec1:SetRange(LOCATION_MZONE)
    ec1:SetLabel(zones)
    ec1:SetOperation(function(e) return e:GetLabel() end)
    ec1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
    c:RegisterEffect(ec1)
end

function s.e2con(e)
    local c = e:GetHandler()
    return c:GetOverlayCount() > 0 and
               Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_FZONE, 0,
                                           1, nil)
end

function s.e2val(e, te) return te:GetOwner() ~= e:GetOwner() end

function s.e4tg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return not c:IsReason(REASON_REPLACE) and
                   c:CheckRemoveOverlayCard(tp, 1, REASON_EFFECT)
    end

    if Duel.SelectEffectYesNo(tp, c, 96) then
        c:RemoveOverlayCard(tp, 1, 1, REASON_EFFECT)
        return true
    else
        return false
    end
end
