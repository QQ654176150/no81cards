--蕾娜·莉希特娜瓦
function c9910380.initial_effect(c)
	aux.AddCodeList(c,9910376)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910380,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c9910380.ntcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c9910380.discon)
	c:RegisterEffect(e2)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c9910380.condition1)
	e4:SetCost(c9910380.cost)
	e4:SetTarget(c9910380.target1)
	e4:SetOperation(c9910380.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(0)
	e5:SetCondition(c9910380.condition2)
	e5:SetTarget(c9910380.target2)
	c:RegisterEffect(e5)
	--unreleaseable sum
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	e6:SetValue(1)
	e6:SetCondition(c9910380.relcon)
	c:RegisterEffect(e6)
	--summon with no tribute
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SUMMON_PROC)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_HAND,0)
	e8:SetCondition(c9910380.tricon)
	c:RegisterEffect(e8)
end
function c9910380.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function c9910380.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c9910380.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (Duel.GetTurnPlayer()~=tp or not Duel.IsPlayerAffectedByEffect(tp,9910376))
end
function c9910380.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetTurnPlayer()==tp and Duel.IsPlayerAffectedByEffect(tp,9910376)
end
function c9910380.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9910380.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c9910380.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,c) then
		local flag=c:GetFlagEffectLabel(9910380)
		if flag then
			c:SetFlagEffectLabel(9910380,1)
		else
			c:RegisterFlagEffect(9910380,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		end
	else
		local flag=c:GetFlagEffectLabel(9910393)
		if flag then
			c:SetFlagEffectLabel(9910393,1)
		else
			c:RegisterFlagEffect(9910393,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		end
	end
	local loc=LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED 
	local b1=Duel.IsExistingMatchingCard(c9910380.filter,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,9910380)==0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910380.spfilter,tp,loc,0,1,nil,e,tp)
	c:SetFlagEffectLabel(9910380,0)
	c:SetFlagEffectLabel(9910393,0)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,loc)
end
function c9910380.filter(c)
	return aux.IsCodeListed(c,9910376) and c:IsSummonable(true,nil)
end
function c9910380.spfilter(c,e,tp)
	return c:IsCode(9910376) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c9910380.operation(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED 
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c9910380.spfilter),tp,loc,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,9910380)==0 and Duel.SelectYesNo(tp,aux.Stringid(9910380,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910380.spfilter),tp,loc,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.RegisterFlagEffect(tp,9910380,0,0,1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910380.filter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Summon(tp,g:GetFirst(),true,nil)
		end
	end
end
function c9910380.relcon(e)
	local ct=e:GetHandler():GetFlagEffectLabel(9910380)
	return ct and ct>0
end
function c9910380.tricon(e,c,minc)
	local ct=e:GetHandler():GetFlagEffectLabel(9910393)
	if c==nil then return ct and ct>0 end
	return ct and ct>0 and minc==0
end
