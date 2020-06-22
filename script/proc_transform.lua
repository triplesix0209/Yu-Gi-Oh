if not aux.TransformProcedure then
    aux.TransformProcedure = {}
    Transform = aux.TransformProcedure
end
if not Transform then Transform = aux.TransformProcedure end

-- constant
Transform.TYPE = 0x20000000
Transform.TEXT_TRANSFORM_MATERIAL = aux.Stringid(400000000, 0)
Transform.TEXT_SELF_TO_GRAVE = aux.Stringid(400000000, 1)

-- function
function Transform.AddProcedure(c, matfilter)
    -- outside 
    local outside = Effect.CreateEffect(c)
    outside:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    outside:SetProperty(EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE)
    outside:SetCode(EVENT_STARTUP)
    outside:SetRange(0x5f)
    outside:SetOperation(function(e)
        Duel.DisableShuffleCheck()
        Duel.SendtoDeck(e:GetOwner(), nil, -2, REASON_RULE)
    end)
    c:RegisterEffect(outside)

    -- turn back when leave field
    local turnback = Effect.CreateEffect(c)
    turnback:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    turnback:SetProperty(EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE)
    turnback:SetCode(EVENT_LEAVE_FIELD)
    turnback:SetRange(LOCATION_MZONE)
    turnback:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        return e:GetHandler():GetLocation() ~= 0
    end)
    turnback:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local mc = c:GetMaterial():GetFirst()
        local mtp = mc:GetOwner()
        local pos = c:GetPosition()
        local loc = c:GetLocation()
        local reason = c:GetReason()
        local sequence = c:GetSequence()

        if c:GetReasonEffect() then
            mc:SetReasonEffect(c:GetReasonEffect())
        end
        if c:GetReasonPlayer() then
            mc:SetReasonPlayer(c:GetReasonPlayer())
        end
        if c:GetReasonCard() then mc:SetReasonCard(c:GetReasonCard()) end

        Duel.SendtoDeck(c, tp, -2, REASON_RULE)
        if loc == LOCATION_DECK then
            Duel.SendtoDeck(mc, mtp, sequence, reason)
        elseif loc == LOCATION_HAND then
            Duel.SendtoHand(mc, mtp, reason)
        elseif loc == LOCATION_GRAVE then
            Duel.SendtoGrave(mc, reason)
        elseif loc == LOCATION_REMOVED then
            Duel.Remove(mc, pos, reason)
        end
    end)
    c:RegisterEffect(turnback)

    -- transform summon
    if matfilter then
        local trans = Effect.CreateEffect(c)
        trans:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        trans:SetCode(EVENT_FREE_CHAIN)
        trans:SetCountLimit(1)
        trans:SetCondition(Transform.Condition(matfilter))
        trans:SetOperation(Transform.Operation(matfilter))
        Duel.RegisterEffect(trans, nil)
    end
end

function Transform.Summon(c, trans_player, target_player, mc, pos)
    if not pos then pos = POS_FACEUP end

    local zone = 0xff
    if trans_player == target_player then
        zone = mc:GetSequence()
        zone = 2 ^ zone
    end

    c:SetMaterial(Group.FromCards(mc))
    Duel.SendtoDeck(mc, nil, -2, REASON_MATERIAL + REASON_RULE)
    Duel.MoveToField(c, trans_player, target_player, LOCATION_MZONE, pos, true,
                     zone)
    Debug.PreSummon(c, mc:GetSummonType(), mc:GetSummonLocation())

    -- not allow change posiiton
    local nochangepos = Effect.CreateEffect(c)
    nochangepos:SetType(EFFECT_TYPE_SINGLE)
    nochangepos:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    nochangepos:SetReset(RESET_PHASE + PHASE_END)
    c:RegisterEffect(nochangepos)
end

function Transform.Detransform(c, trans_player, target_player, pos)
    local mc = c:GetMaterial():GetFirst()
    if not pos then pos = POS_FACEUP end

    local zone = 0xff
    if trans_player == target_player then
        zone = c:GetSequence()
        zone = 2 ^ zone
    end

    Duel.SendtoDeck(c, target_player, -2, REASON_RULE)
    Duel.MoveToField(mc, trans_player, target_player, LOCATION_MZONE, pos, true,
                     zone)

    -- not allow change posiiton
    local nochangepos = Effect.CreateEffect(mc)
    nochangepos:SetType(EFFECT_TYPE_SINGLE)
    nochangepos:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    nochangepos:SetReset(RESET_PHASE + PHASE_END)
    mc:RegisterEffect(nochangepos)

    return mc
end

function Transform.Condition(matfilter)
    return function(e, tp, eg, ep, ev, re, r, rp)
        tp = e:GetOwner():GetOwner()
        local c = e:GetHandler()
        return e:GetHandler():GetLocation() == 0 and
                   Duel.IsExistingMatchingCard(matfilter, tp, LOCATION_MZONE, 0,
                                               1, nil, tp, c)

    end
end

function Transform.Operation(matfilter)
    return function(e, tp, eg, ep, ev, re, r, rp)
        tp = e:GetOwner():GetOwner()
        local c = e:GetHandler()

        Duel.Hint(HINT_SELECTMSG, tp, Transform.TEXT_TRANSFORM_MATERIAL)
        local tc = Duel.SelectMatchingCard(tp, matfilter, tp, LOCATION_MZONE, 0,
                                           1, 1, nil, tp, c):GetFirst()
        if not tc then return end
        Duel.BreakEffect()

        Transform.Summon(c, tp, tp, tc, POS_FACEUP)
    end
end