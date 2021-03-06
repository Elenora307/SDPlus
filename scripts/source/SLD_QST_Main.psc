Scriptname SLD_QST_Main extends Quest  

HeadPart playerOrigHair = None
HeadPart playerCurrentHair

Function SetNPCDialogueState ( Actor akSpeaker )
	ObjectReference akSpeakerRef = akSpeaker as objectReference
	Form kSpeakerForm = akSpeaker as Form
	Actor Player = Game.GetPlayer()
	Bool isPCBimbo = False
	Bool isSpeakerHuman = kSpeakerForm.HasKeywordString("ActorTypeNPC")
	Int iDominance = StorageUtil.GetIntValue( Player , "_SD_iDom") - StorageUtil.GetIntValue( Player , "_SD_iSub")

	; Force disable test dialogues
	If (_SLD_TestDialogues.GetValue() != 0)
		_SLD_TestDialogues.SetValue(0)
	EndIf

	_SLD_speakerAlias.ForceRefTo(akSpeakerRef )

	if ( (akSpeaker as ObjectReference).GetAnimationVariableInt("iDrunkVariable") == 1)
		; Debug.Notification("NPC drunk state: " + (akSpeaker as ObjectReference).GetAnimationVariableInt("iDrunkVariable"))
		_SLD_NPCdrunk.SetValue(1)
	Else
		_SLD_NPCdrunk.SetValue(0)
	EndIf

	; Variables (use StorageUtil - aliases only for AI packages) 
	; - Time first met
	; - Time last met
	; - AI status ( following, in scene, default AI )
	; - Interest level
	; - Relationship level with Player (same as RelationshipRank, from -7 to +7)

	If (StorageUtil.HasIntValue(akSpeaker, "_SD_iRelationshipType"))
		_SLD_NPCRelationshipType.SetValue( StorageUtil.GetIntValue(akSpeaker, "_SD_iRelationshipType") )
	Else
		_SLD_NPCRelationshipType.SetValue( akSpeaker.GetRelationshipRank(Player) )
	EndIf

	isPCBimbo = StorageUtil.GetIntValue(Player, "_SLH_iBimbo") as Bool

	If isPCBimbo  
		; Enable Bimbo Override as single rape (for now)
		StorageUtil.SetIntValue( Player , "_SD_iSlaveryLevel", 6)
	Endif

	If (_SLD_NPCRelationshipType.GetValue() < -4) && ( (StorageUtil.GetFormValue(Player, "_SD_CurrentOwner") as ObjectReference) == akSpeakerRef)
		If (isSpeakerHuman) && (_SLD_humanMasterAlias.GetReference() != akSpeakerRef)
			_SLD_humanMasterAlias.ForceRefTo(akSpeakerRef )
		ElseIf (!isSpeakerHuman) && (_SLD_beastMasterAlias.GetReference() != akSpeakerRef)
			_SLD_beastMasterAlias.ForceRefTo(akSpeakerRef )
		EndIf

	ElseIf (_SLD_NPCRelationshipType.GetValue() > 4)
		If (isSpeakerHuman) && (_SLD_humanSlaveAlias.GetReference() != akSpeakerRef)
			_SLD_humanSlaveAlias.ForceRefTo(akSpeakerRef )
		ElseIf (!isSpeakerHuman) &&  (_SLD_beastSlaveAlias.GetReference() != akSpeakerRef)
			_SLD_beastSlaveAlias.ForceRefTo(akSpeakerRef )
		EndIf

	ElseIf (_SLD_NPCRelationshipType.GetValue() > 2 )
		If (isSpeakerHuman) && (_SLD_humanLoverAlias.GetReference() != akSpeakerRef)
			_SLD_humanLoverAlias.ForceRefTo(akSpeakerRef )
		ElseIf (!isSpeakerHuman) &&  (_SLD_beastLoverAlias.GetReference() != akSpeakerRef)
			_SLD_beastLoverAlias.ForceRefTo(akSpeakerRef )
		EndIf

	EndIf
	

	If (StorageUtil.HasIntValue( Player, "_SD_iSlaveryLevel"))
		_SLD_PCSubSlaveryLevel.SetValue(  StorageUtil.GetIntValue( Player , "_SD_iSlaveryLevel") )
	Else
		_SLD_PCSubSlaveryLevel.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Player, "_SD_iEnslaved"))
		_SLD_PCSubEnslaved.SetValue(  StorageUtil.GetIntValue( Player , "_SD_iEnslaved") )
	Else
		_SLD_PCSubEnslaved.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iForcedSlavery"))
		_SLD_PCSubForcedSlavery.SetValue(  StorageUtil.GetIntValue( akSpeaker  , "_SD_iForcedSlavery") )
	Else
		_SLD_PCSubForcedSlavery.SetValue( 0 )
	EndIf


	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iDisposition"))
		_SLD_NPCdisposition.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iDisposition") )
	Else
		_SLD_NPCdisposition.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iTrust"))
		_SLD_NPCtrust.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iTrust") )
	Else
		_SLD_NPCtrust.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iSeduction"))
		_SLD_NPCseduction.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iSeduction") )
	Else
		_SLD_NPCseduction.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iCorruption"))
		_SLD_NPCcorruption.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iCorruption") )
	Else
		_SLD_NPCcorruption.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( akSpeaker , "_SD_iFollowSlave"))
		_SLD_PCSubFollowSlave.SetValue(  StorageUtil.GetIntValue( akSpeaker , "_SD_iFollowSlave") )
	Else
		_SLD_PCSubFollowSlave.SetValue( 0 )
	EndIf

	If (StorageUtil.HasStringValue( Player , "_SD_sDefaultStance"))
		If (StorageUtil.GetStringValue( Player, "_SD_sDefaultStance") == "Crawling")
			_SLD_PCSubDefaultStance.SetValue(  2 )
		ElseIf (StorageUtil.GetStringValue( Player, "_SD_sDefaultStance") == "Kneeling")
			_SLD_PCSubDefaultStance.SetValue(  1 )
		ElseIf (StorageUtil.GetStringValue( Player, "_SD_sDefaultStance") == "Standing")
			_SLD_PCSubDefaultStance.SetValue(  0 )
		EndIf
	Else
		_SLD_PCSubDefaultStance.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Player , "_SD_iEnableStand"))
		_SLD_PCSubEnableStand.SetValue(  StorageUtil.GetIntValue( Player , "_SD_iEnableStand") )
	Else
		_SLD_PCSubEnableStand.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Player , "_SD_iEnableLeash"))
		_SLD_PCSubEnableLeash.SetValue(  StorageUtil.GetIntValue( Player , "_SD_iEnableLeash") )
	Else
		_SLD_PCSubEnableLeash.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Player , "_SD_iHandsFree"))
		_SLD_PCSubHandsFree.SetValue(  StorageUtil.GetIntValue( Player , "_SD_iHandsFree") )
	Else
		_SLD_PCSubHandsFree.SetValue( 0 )
	EndIf

	If (StorageUtil.HasIntValue( Player , "_SD_iDominance"))
		_SLD_PCSubDominance.SetValue(  StorageUtil.GetIntValue( Player , "_SD_iDominance") )
	Else
		_SLD_PCSubDominance.SetValue( 0 )
	EndIf


	; - Feedom status ( bought by player, sold to NPC, whoring, free )
	; - Bound location  ( editor location, set to nearby map marker )
	; - Leash length (radius around bound location)
	; - Wander duration buffer
	; - Bound owner ( set to Player, other NPC or self for freedom)

	; Temporary global variable
	; - Arousal level (from sexlab aroused)
	; - Purity level (from sexlab)
	; - Sexuality (from sexlab)

	; - NPC sex count (from sexlab)
	_SLD_NPCSexCount.SetValue(  SexLab.PlayerSexCount( akSpeaker ) )

	; - Last time sex (from sexlab)

	if ( _SLD_NPCdisposition.GetValue() > 0 )
		Debug.Notification("(smiling)")

	Elseif ( _SLD_NPCdisposition.GetValue() < 0 )
		Debug.Notification("(frowning)")

	Endif

	; Debug.Notification("[SLD] _SLD_humanMasterAlias: " + _SLD_humanMasterAlias.GetReference() as Actor)

	Debug.Trace("[SLD] " + akSpeaker + " sex: " + _SLD_NPCSexCount.GetValue( ) + " - Rel: " +  _SLD_NPCRelationshipType.GetValue() + " - Slavery: " +  _SLD_PCSubSlaveryLevel.GetValue() )
	Debug.Trace("[SLD] Human speaker: " + isSpeakerHuman )
	Debug.Trace("[SLD] _SLD_speakerAlias: " + _SLD_speakerAlias.GetReference() as Actor)
	Debug.Trace("[SLD] _SLD_humanLoverAlias: " + _SLD_humanLoverAlias.GetReference() as Actor) 
	Debug.Trace("[SLD] _SLD_beastLoverAlias: " + _SLD_beastLoverAlias.GetReference() as Actor)  
	Debug.Trace("[SLD] _SLD_humanMasterAlias: " + _SLD_humanMasterAlias.GetReference() as Actor)
	Debug.Trace("[SLD] _SLD_humanSlaveAlias: " + _SLD_humanSlaveAlias.GetReference() as Actor)
	Debug.Trace("[SLD] _SLD_beastMasterAlias: " + _SLD_beastMasterAlias.GetReference() as Actor)
	Debug.Trace("[SLD] _SLD_beastSlaveAlias: " + _SLD_beastSlaveAlias.GetReference() as Actor)
	Debug.Trace("[SLD] Disposition: " + _SLD_NPCdisposition.GetValue( ) as Int + " Trust: " + _SLD_NPCtrust.GetValue( ) as Int + " Seduction: " + _SLD_NPCseduction.GetValue( ) as Int + " Corruption: " + _SLD_NPCcorruption.GetValue( ) as Int)
	Debug.Trace("[SLD] Leash: " + _SLD_PCSubEnableLeash.GetValue( ) as Int + " Stance: " + _SLD_PCSubDefaultStance.GetValue( ) as Int )

EndFunction



Function StartPlayerRape ( Actor akSpeaker, string tags = "Sex" )
	Actor Player = Game.GetPlayer()
	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(Player as ObjectReference, "bleedOutStart")

	Int IButton = _SLD_rapeMenu.Show()

	If IButton == 0 ; Show the thing.

		; If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
			; Debug.Notification( "[Resists weakly]" )
		;	SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = SexLab.PlayerRef , AnimationTags = tags)
		; EndIf
		StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)

		Int randomNum = Utility.RandomInt(0, 100)
		; StorageUtil.SetFormValue( Player , "_SD_TempAggressor", akSpeaker)

		akSpeaker.SendModEvent("PCSubSex") ; Sex

	Else
		StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)

		SexLab.ActorLib.StripActor( SexLab.PlayerRef, VictimRef = SexLab.PlayerRef, DoAnimate= false)
	EndIf

EndFunction

Function StartPlayerGangRape ( Actor akSpeaker, string tags = "Sex" )
	Actor Player = Game.GetPlayer()
	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(Player as ObjectReference, "bleedOutStart")

	Int IButton = _SLD_rapeMenu.Show()

	If IButton == 0 ; Show the thing.

		; If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
			; Debug.Notification( "[Resists weakly]" )
		;	SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = SexLab.PlayerRef , AnimationTags = tags)
		; EndIf
			
		StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)

		Int randomNum = Utility.RandomInt(0, 100)
		; StorageUtil.SetFormValue( Player , "_SD_TempAggressor", akSpeaker)

		If (randomNum > 70)
			Debug.Notification("Dance for us...")
			akSpeaker.SendModEvent("PCSubEntertain") ; Dance
		ElseIf (randomNum > 50)
			Debug.Notification("Show us what you can do...")
			akSpeaker.SendModEvent("PCSubEntertain", "Soloshow") ; Show
		ElseIf (randomNum > 30)
			Debug.Notification("Help yourselves boys!...")
			akSpeaker.SendModEvent("PCSubEntertain", "Gangbang") ; Gang bang
		Else
			Debug.Notification("Get on your knees and lift up that ass of yours...")
			akSpeaker.SendModEvent("PCSubSex") ; Sex
		EndIf



	Else
		StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)

		SexLab.ActorLib.StripActor( SexLab.PlayerRef, VictimRef = SexLab.PlayerRef, DoAnimate= false)
	EndIf

EndFunction


Function StartPlayerRapist ( Actor akSpeaker, string tags = "" )
	Bool isVictim = True
	Int randomNum = Utility.RandomInt(0, 100)

	Game.ForceThirdPerson()
	Debug.SendAnimationEvent( akSpeaker as ObjectReference, "bleedOutStart")

	if ( (akSpeaker as ObjectReference).GetAnimationVariableInt("iDrunkVariable") == 1)
		If ( Utility.RandomInt(0, 100) > 30 )
			isVictim = False
		Endif
	else
		If ( Utility.RandomInt(0, 100) > 80 )
			isVictim = False
		Endif
	endif

	Int IButton = _SLD_rapistMenu.Show()

	If IButton == 0 ; Undress
		if (isVictim)
			SexLab.ActorLib.StripActor( akSpeaker, VictimRef = akSpeaker, DoAnimate= false)
		else
			SexLab.ActorLib.StripActor( akSpeaker, DoAnimate= false)
		Endif

	else

		If (tags == "")
			If IButton == 1 ; Fondle
				tags = "Foreplay"
			ElseIf IButton == 2 ; Oral
				tags = "Oral"
			ElseIf IButton == 3 ; Slow sex
				tags = "Loving"
			ElseIf IButton == 4 ; Rough
				tags = "Rough"
			ElseIf IButton == 5 ; Nothing
				tags = ""
			EndIf
		Endif

		If (tags != "")
			StorageUtil.SetIntValue( akSpeaker , "_SD_iSub", StorageUtil.GetIntValue( akSpeaker, "_SD_iSub") + 1)

			If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
				Debug.Notification( "[Resists weakly]" )
				If (isVictim)
					SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, Victim = akSpeaker , AnimationTags = tags)
				Else
					SexLab.QuickStart(SexLab.PlayerRef,  akSpeaker, AnimationTags = tags)
				Endif
			EndIf
		Endif

;	Else
;		Debug.MessageBox("Your victim struggles and pushes back at you.")
;		StorageUtil.SetIntValue( akSpeaker , "_SD_iDom", StorageUtil.GetIntValue( akSpeaker, "_SD_iDom") + 1)

	EndIf

EndFunction

Function ChangePlayerLook ( Actor akSpeaker, string type = "Racemenu" )
 	Actor Player = Game.GetPlayer()
	Utility.Wait(0.5)

	Int IButton = _SLD_raceMenu.Show()

	If IButton == 0  ; Show the thing.
		StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)

		Actor kPlayer = Player as Actor

		Int   iPlayerGender = kPlayer.GetLeveledActorBase().GetSex() as Int

		Int Hair = kPlayer.GetLeveledActorBase().GetNumHeadParts()
		Int i = 0
		While i < Hair
			If kPlayer.GetLeveledActorBase().GetNthHeadPart(i).GetType() == 3
				playerCurrentHair = kPlayer.GetLeveledActorBase().GetNthHeadPart(i)
				i = Hair
			EndIf
			i += 1
		EndWhile

		If (playerOrigHair == None)
			playerOrigHair = playerCurrentHair
		EndIf

		If (iPlayerGender==0) 
			If (playerCurrentHair != _SLD_MaleSlaveHair) && (Utility.RandomInt(0,100) > 30) && (_SLD_PCSubShavedON.GetValue() ==1)
				kPlayer.ChangeHeadPart(_SLD_MaleSlaveHair)
				Debug.Notification("Your owner shaves your head.")

				SendModEvent("PCSubChangeLook")
			Else
				Game.ShowLimitedRaceMenu()

				SendModEvent("PCSubChangeLook")
			EndIf

		Else
			If (playerCurrentHair != _SLD_FemaleSlaveHair) && (Utility.RandomInt(0,100) > 30) && (_SLD_PCSubShavedON.GetValue() ==1)
				kPlayer.ChangeHeadPart(_SLD_FemaleSlaveHair)
				Debug.Notification("Your owner shaves your head.")

				SendModEvent("PCSubChangeLook")
			Else
				Game.ShowLimitedRaceMenu()

				SendModEvent("PCSubChangeLook")
			EndIf

		EndIf

	Else
		StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)

 
			
	EndIf

	Utility.Wait(1.0)

EndFunction

Function GiftPlayer ( Actor akSpeaker  ) 
	; Player is a beggar
	ObjectReference speakerRef = akSpeaker as ObjectReference

	; Debug.Notification("[SLD] Receiving a gift")

	If akSpeaker.Isinfaction(InnkeeperFaction)
		speakerRef.AddItem(InnkeeperGiftList, 1, true)

	ElseIf akSpeaker.Isinfaction(TailorFaction)
		speakerRef.AddItem(TailorGiftList, 1, true)

	ElseIf akSpeaker.Isinfaction(MerchantFaction)
		speakerRef.AddItem(MerchantGiftList, 1, true)

	ElseIf akSpeaker.Isinfaction(FarmerFaction)
		speakerRef.AddItem(FarmerGiftList, 1, true)

	ElseIf akSpeaker.Isinfaction(PriestFaction)
		speakerRef.AddItem(PriestGiftList, 1, true)

	else
		speakerRef.AddItem(Gold001, Utility.RandomInt(1, ((akSpeaker.GetAV("Confidence") as Int) + (akSpeaker.GetAV("Morality") as Int) ) * (akSpeaker.GetAV("Assistance") as Int) ), true)
	endif

EndFunction

Function RobPlayer ( Actor akSpeaker  )
	Actor Player = Game.GetPlayer()
	Utility.Wait(0.5)

	Int IButton = _SLD_robMenu.Show()

	If IButton == 0  ; Show the thing.

		StorageUtil.SetIntValue( Player , "_SD_iSub", StorageUtil.GetIntValue( Player, "_SD_iSub") + 1)

		Actor _bandit = akSpeaker
		Actor _target = SexLab.PlayerRef 
		int   itemCount
		int   idx
		int   stolenCnt
		int   itemType
		int   cnt
		int   ii
		int   goldVal
		Float itemWeight
		Form  nthItem = None
		Bool  canSteal
		
		itemCount = _target.getNumItems()
		stolenCnt = 0
		while idx < itemCount && stolenCnt < 1
			nthItem = _target.getNthForm(idx)
			if !nthItem
				; _notify("SLU: Null item")
				Return
			endif
		
			canSteal = False
				
			itemType = nthItem.GetType()
			if (itemType == 45) || (itemType == 26) || \
			   (itemType == 41) || (itemType == 30) || \
			   (itemType == 46) || (itemType == 27) || \
			   (itemType == 42) || (itemType == 32)
				canSteal = True
			EndIf
			
			if canSteal && _bandit != SexLab.PlayerRef  && (nthItem.HasKeywordString("VendorNoSale") || nthItem.HasKeywordString("MagicDisallowEnchanting"))
				canSteal = False
				; _notify("Pick: !Q " + nthItem.GetName())
			endif
			
			if canSteal
				cnt = _target.GetItemCount(nthItem)
				goldVal = nthItem.GetGoldValue()
				itemWeight = nthItem.GetWeight()
				
				if (goldVal >= 0)
					if cnt > 1 && goldVal > 0
						ii = Math.Floor(100 / goldVal)
						if ii < cnt
							cnt = ii
						endif
					endif
					
					if cnt > 0
						; Debug.Notification("Pick: " + actorName(_bandit) + " " + actorName(_target))
						Debug.Notification("I like this! [Takes " + cnt + "x " + nthItem.GetName() + " ]")
						_target.RemoveItem(nthItem, cnt, true, _bandit)
						stolenCnt += 1
					endif
				endif
			endif
			
			idx += 1
		endWhile

		cnt = _target.GetItemCount(Gold001)
		if ( (cnt - (cnt/2)) > 10)
			Debug.Notification("You don't need that much money either.")
			_target.RemoveItem(Gold001, cnt/2, true, _bandit)
		endif

	Else
		StorageUtil.SetIntValue( Player , "_SD_iDom", StorageUtil.GetIntValue( Player, "_SD_iDom") + 1)

		SexLab.ActorLib.StripActor( SexLab.PlayerRef, VictimRef = SexLab.PlayerRef, DoAnimate= false)			
	EndIf

	Utility.Wait(1.0)
EndFunction

SexLabFramework Property SexLab  Auto  
ReferenceAlias Property _SLD_speakerAlias  Auto  
ReferenceAlias Property _SLD_humanLoverAlias  Auto  
ReferenceAlias Property _SLD_beastLoverAlias  Auto  
ReferenceAlias Property _SLD_humanMasterAlias  Auto  
ReferenceAlias Property _SLD_humanSlaveAlias  Auto  
ReferenceAlias Property _SLD_beastMasterAlias  Auto  
ReferenceAlias Property _SLD_beastSlaveAlias  Auto  

GlobalVariable Property _SLD_NPCSexCount  Auto  
GlobalVariable Property _SLD_NPCDrunk  Auto  
GlobalVariable Property _SLD_NPCDrugged  Auto  

GlobalVariable Property _SLD_PCSubSlaveryLevel Auto
GlobalVariable Property _SLD_PCSubEnslaved Auto
GlobalVariable Property _SLD_PCSubForcedSlavery Auto

GlobalVariable Property _SLD_PCSubFollowSlave Auto
GlobalVariable Property _SLD_PCSubDefaultStance Auto
GlobalVariable Property _SLD_PCSubEnableStand Auto
GlobalVariable Property _SLD_PCSubEnableLeash Auto
GlobalVariable Property _SLD_PCSubHandsFree Auto
GlobalVariable Property _SLD_PCSubDominance Auto

GlobalVariable Property _SLD_NPCRelationshipType Auto
GlobalVariable Property _SLD_NPCdisposition Auto
GlobalVariable Property _SLD_NPCtrust Auto
GlobalVariable Property _SLD_NPCcorruption Auto
GlobalVariable Property _SLD_NPCseduction Auto


GlobalVariable Property _SLD_TestDialogues Auto

Message Property _SLD_rapeMenu  Auto  

Message Property _SLD_rapistMenu  Auto  

Message Property _SLD_raceMenu  Auto  

Message Property _SLD_robMenu  Auto  

 

HeadPart Property _SLD_FemaleSlaveHair  Auto  

HeadPart Property _SLD_MaleSlaveHair  Auto  

GlobalVariable Property _SLD_PCSubShavedON  Auto  
MiscObject Property Gold001  Auto  

Faction Property InnkeeperFaction  Auto  
Faction Property TailorFaction  Auto  
Faction Property MerchantFaction  Auto  
Faction Property FarmerFaction  Auto  
Faction Property PriestFaction  Auto  

LeveledItem Property InnkeeperGiftList Auto  
LeveledItem Property TailorGiftList Auto  
LeveledItem Property MerchantGiftList Auto  
LeveledItem Property FarmerGiftList Auto  
LeveledItem Property PriestGiftList Auto  
