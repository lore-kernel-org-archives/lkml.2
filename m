Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1GLKkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:40:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59549 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1GLKkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:40:32 -0400
Date: Tue, 12 Jul 2011 16:26:33 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: mikem@ring3k.org, pshah.mumbai@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Staging: rtl8192e: fixed style issues found by
	checkpatch.pl
Message-ID: <20110712105633.GA18230@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8190_rtl8256.c file that fixes whitespace
related style issues found by the checkpatch.pl tool

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/rtl8192e/r8190_rtl8256.c |  114 +++++++++++++++---------------
 1 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8190_rtl8256.c b/drivers/staging/rtl8192e/r8190_rtl8256.c
index 286462c..24430b9 100644
--- a/drivers/staging/rtl8192e/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192e/r8190_rtl8256.c
@@ -28,15 +28,15 @@ void PHY_SetRF8256Bandwidth(struct r8192_priv *priv, HT_CHANNEL_WIDTH Bandwidth)
 	u8	eRFPath;
 
 	//for(eRFPath = RF90_PATH_A; eRFPath <pHalData->NumTotalRFPath; eRFPath++)
-	for(eRFPath = 0; eRFPath <priv->NumTotalRFPath; eRFPath++)
+	for (eRFPath = 0; eRFPath < priv->NumTotalRFPath; eRFPath++)
 	{
 		if (!rtl8192_phy_CheckIsLegalRFPath(priv, eRFPath))
 				continue;
 
-		switch(Bandwidth)
+		switch (Bandwidth)
 		{
 			case HT_CHANNEL_WIDTH_20:
-				if(priv->card_8192_version == VERSION_8190_BD || priv->card_8192_version == VERSION_8190_BE)// 8256 D-cut, E-cut, xiong: consider it later!
+				if (priv->card_8192_version == VERSION_8190_BD || priv->card_8192_version == VERSION_8190_BE)// 8256 D-cut, E-cut, xiong: consider it later!
 				{
 					rtl8192_phy_SetRFReg(priv, (RF90_RADIO_PATH_E)eRFPath, 0x0b, bMask12Bits, 0x100); //phy para:1ba
 					rtl8192_phy_SetRFReg(priv, (RF90_RADIO_PATH_E)eRFPath, 0x2c, bMask12Bits, 0x3d7);
@@ -52,7 +52,7 @@ void PHY_SetRF8256Bandwidth(struct r8192_priv *priv, HT_CHANNEL_WIDTH Bandwidth)
 
 				break;
 			case HT_CHANNEL_WIDTH_20_40:
-				if(priv->card_8192_version == VERSION_8190_BD ||priv->card_8192_version == VERSION_8190_BE)// 8256 D-cut, E-cut, xiong: consider it later!
+				if (priv->card_8192_version == VERSION_8190_BD || priv->card_8192_version == VERSION_8190_BE)// 8256 D-cut, E-cut, xiong: consider it later!
 				{
 					rtl8192_phy_SetRFReg(priv, (RF90_RADIO_PATH_E)eRFPath, 0x0b, bMask12Bits, 0x300); //phy para:3ba
 					rtl8192_phy_SetRFReg(priv, (RF90_RADIO_PATH_E)eRFPath, 0x2c, bMask12Bits, 0x3ff);
@@ -67,7 +67,7 @@ void PHY_SetRF8256Bandwidth(struct r8192_priv *priv, HT_CHANNEL_WIDTH Bandwidth)
 
 				break;
 			default:
-				RT_TRACE(COMP_ERR, "PHY_SetRF8256Bandwidth(): unknown Bandwidth: %#X\n",Bandwidth );
+				RT_TRACE(COMP_ERR, "PHY_SetRF8256Bandwidth(): unknown Bandwidth: %#X\n", Bandwidth);
 				break;
 
 		}
@@ -113,7 +113,7 @@ RT_STATUS phy_RF8256_Config_ParaFile(struct r8192_priv *priv)
 	//3//-----------------------------------------------------------------
 	//3// <2> Initialize RF
 	//3//-----------------------------------------------------------------
-	for(eRFPath = (RF90_RADIO_PATH_E)RF90_PATH_A; eRFPath <priv->NumTotalRFPath; eRFPath++)
+	for (eRFPath = (RF90_RADIO_PATH_E)RF90_PATH_A; eRFPath < priv->NumTotalRFPath; eRFPath++)
 	{
 		if (!rtl8192_phy_CheckIsLegalRFPath(priv, eRFPath))
 				continue;
@@ -121,13 +121,13 @@ RT_STATUS phy_RF8256_Config_ParaFile(struct r8192_priv *priv)
 		pPhyReg = &priv->PHYRegDef[eRFPath];
 
 		/*----Store original RFENV control type----*/
-		switch(eRFPath)
+		switch (eRFPath)
 		{
 		case RF90_PATH_A:
 		case RF90_PATH_C:
 			u4RegValue = rtl8192_QueryBBReg(priv, pPhyReg->rfintfs, bRFSI_RFENV);
 			break;
-		case RF90_PATH_B :
+		case RF90_PATH_B:
 		case RF90_PATH_D:
 			u4RegValue = rtl8192_QueryBBReg(priv, pPhyReg->rfintfs, bRFSI_RFENV<<16);
 			break;
@@ -148,7 +148,7 @@ RT_STATUS phy_RF8256_Config_ParaFile(struct r8192_priv *priv)
 		/*----Check RF block (for FPGA platform only)----*/
 		// TODO: this function should be removed on ASIC , Emily 2007.2.2
 		rtStatus = rtl8192_phy_checkBBAndRF(priv, HW90_BLOCK_RF, (RF90_RADIO_PATH_E)eRFPath);
-		if(rtStatus!= RT_STATUS_SUCCESS)
+		if (rtStatus != RT_STATUS_SUCCESS)
 		{
 			RT_TRACE(COMP_ERR, "PHY_RF8256_Config():Check Radio[%d] Fail!!\n", eRFPath);
 			goto phy_RF8256_Config_ParaFile_Fail;
@@ -157,39 +157,39 @@ RT_STATUS phy_RF8256_Config_ParaFile(struct r8192_priv *priv)
 		RetryTimes = ConstRetryTimes;
 		RF3_Final_Value = 0;
 		/*----Initialize RF fom connfiguration file----*/
-		switch(eRFPath)
+		switch (eRFPath)
 		{
 		case RF90_PATH_A:
-			while(RF3_Final_Value!=RegValueToBeCheck && RetryTimes!=0)
+			while (RF3_Final_Value != RegValueToBeCheck && RetryTimes != 0)
 			{
-				ret = rtl8192_phy_ConfigRFWithHeaderFile(priv,(RF90_RADIO_PATH_E)eRFPath);
+				ret = rtl8192_phy_ConfigRFWithHeaderFile(priv, (RF90_RADIO_PATH_E)eRFPath);
 				RF3_Final_Value = rtl8192_phy_QueryRFReg(priv, (RF90_RADIO_PATH_E)eRFPath, RegOffSetToBeCheck, bMask12Bits);
 				RT_TRACE(COMP_RF, "RF %d %d register final value: %x\n", eRFPath, RegOffSetToBeCheck, RF3_Final_Value);
 				RetryTimes--;
 			}
 			break;
 		case RF90_PATH_B:
-			while(RF3_Final_Value!=RegValueToBeCheck && RetryTimes!=0)
+			while (RF3_Final_Value != RegValueToBeCheck && RetryTimes != 0)
 			{
-				ret = rtl8192_phy_ConfigRFWithHeaderFile(priv,(RF90_RADIO_PATH_E)eRFPath);
+				ret = rtl8192_phy_ConfigRFWithHeaderFile(priv, (RF90_RADIO_PATH_E)eRFPath);
 				RF3_Final_Value = rtl8192_phy_QueryRFReg(priv, (RF90_RADIO_PATH_E)eRFPath, RegOffSetToBeCheck, bMask12Bits);
 				RT_TRACE(COMP_RF, "RF %d %d register final value: %x\n", eRFPath, RegOffSetToBeCheck, RF3_Final_Value);
 				RetryTimes--;
 			}
 			break;
 		case RF90_PATH_C:
-			while(RF3_Final_Value!=RegValueToBeCheck && RetryTimes!=0)
+			while (RF3_Final_Value != RegValueToBeCheck && RetryTimes != 0)
 			{
-				ret = rtl8192_phy_ConfigRFWithHeaderFile(priv,(RF90_RADIO_PATH_E)eRFPath);
+				ret = rtl8192_phy_ConfigRFWithHeaderFile(priv, (RF90_RADIO_PATH_E)eRFPath);
 				RF3_Final_Value = rtl8192_phy_QueryRFReg(priv, (RF90_RADIO_PATH_E)eRFPath, RegOffSetToBeCheck, bMask12Bits);
 				RT_TRACE(COMP_RF, "RF %d %d register final value: %x\n", eRFPath, RegOffSetToBeCheck, RF3_Final_Value);
 				RetryTimes--;
 			}
 			break;
 		case RF90_PATH_D:
-			while(RF3_Final_Value!=RegValueToBeCheck && RetryTimes!=0)
+			while (RF3_Final_Value != RegValueToBeCheck && RetryTimes != 0)
 			{
-				ret = rtl8192_phy_ConfigRFWithHeaderFile(priv,(RF90_RADIO_PATH_E)eRFPath);
+				ret = rtl8192_phy_ConfigRFWithHeaderFile(priv, (RF90_RADIO_PATH_E)eRFPath);
 				RF3_Final_Value = rtl8192_phy_QueryRFReg(priv, (RF90_RADIO_PATH_E)eRFPath, RegOffSetToBeCheck, bMask12Bits);
 				RT_TRACE(COMP_RF, "RF %d %d register final value: %x\n", eRFPath, RegOffSetToBeCheck, RF3_Final_Value);
 				RetryTimes--;
@@ -198,19 +198,19 @@ RT_STATUS phy_RF8256_Config_ParaFile(struct r8192_priv *priv)
 		}
 
 		/*----Restore RFENV control type----*/;
-		switch(eRFPath)
+		switch (eRFPath)
 		{
 		case RF90_PATH_A:
 		case RF90_PATH_C:
 			rtl8192_setBBreg(priv, pPhyReg->rfintfs, bRFSI_RFENV, u4RegValue);
 			break;
-		case RF90_PATH_B :
+		case RF90_PATH_B:
 		case RF90_PATH_D:
 			rtl8192_setBBreg(priv, pPhyReg->rfintfs, bRFSI_RFENV<<16, u4RegValue);
 			break;
 		}
 
-		if(ret){
+		if (ret) {
 			RT_TRACE(COMP_ERR, "phy_RF8256_Config_ParaFile():Radio[%d] Fail!!", eRFPath);
 			goto phy_RF8256_Config_ParaFile_Fail;
 		}
@@ -231,14 +231,14 @@ void PHY_SetRF8256CCKTxPower(struct r8192_priv *priv, u8 powerlevel)
 	u32	TxAGC=0;
 
 	TxAGC = powerlevel;
-	if(priv->bDynamicTxLowPower == true)//cosa 04282008 for cck long range
+	if (priv->bDynamicTxLowPower == true)//cosa 04282008 for cck long range
 	{
-		if(priv->CustomerID == RT_CID_819x_Netcore)
+		if (priv->CustomerID == RT_CID_819x_Netcore)
 		TxAGC = 0x22;
 	else
 		TxAGC += priv->CckPwEnl;
 	}
-	if(TxAGC > 0x24)
+	if (TxAGC > 0x24)
 		TxAGC = 0x24;
 	rtl8192_setBBreg(priv, rTxAGC_CCK_Mcs32, bTxAGCRateCCK, TxAGC);
 }
@@ -253,39 +253,39 @@ void PHY_SetRF8256OFDMTxPower(struct r8192_priv *priv, u8 powerlevel)
 	u8 byte0, byte1, byte2, byte3;
 
 	powerBase0 = powerlevel + priv->LegacyHTTxPowerDiff;	//OFDM rates
-	powerBase0 = (powerBase0<<24) | (powerBase0<<16) |(powerBase0<<8) |powerBase0;
+	powerBase0 = (powerBase0<<24) | (powerBase0<<16) | (powerBase0<<8) | powerBase0;
 	powerBase1 = powerlevel;							//MCS rates
-	powerBase1 = (powerBase1<<24) | (powerBase1<<16) |(powerBase1<<8) |powerBase1;
+	powerBase1 = (powerBase1<<24) | (powerBase1<<16) | (powerBase1<<8) | powerBase1;
 
-	for(index=0; index<6; index++)
+	for (index = 0; index < 6; index++)
 	{
-		writeVal = priv->MCSTxPowerLevelOriginalOffset[index] + ((index<2)?powerBase0:powerBase1);
+		writeVal = priv->MCSTxPowerLevelOriginalOffset[index] + ((index < 2) ? powerBase0 : powerBase1);
 		byte0 = (u8)(writeVal & 0x7f);
 		byte1 = (u8)((writeVal & 0x7f00)>>8);
 		byte2 = (u8)((writeVal & 0x7f0000)>>16);
 		byte3 = (u8)((writeVal & 0x7f000000)>>24);
-		if(byte0 > 0x24)	// Max power index = 0x24
+		if (byte0 > 0x24)	// Max power index = 0x24
 			byte0 = 0x24;
-		if(byte1 > 0x24)
+		if (byte1 > 0x24)
 			byte1 = 0x24;
-		if(byte2 > 0x24)
+		if (byte2 > 0x24)
 			byte2 = 0x24;
-		if(byte3 > 0x24)
+		if (byte3 > 0x24)
 			byte3 = 0x24;
 
-		if(index == 3)
+		if (index == 3)
 		{
-			writeVal_tmp = (byte3<<24) | (byte2<<16) |(byte1<<8) |byte0;
+			writeVal_tmp = (byte3<<24) | (byte2<<16) | (byte1<<8) | byte0;
 			priv->Pwr_Track = writeVal_tmp;
 		}
 
-		if(priv->bDynamicTxHighPower == true)     //Add by Jacken 2008/03/06  //when DM implement, add this
+		if (priv->bDynamicTxHighPower == true)     //Add by Jacken 2008/03/06  //when DM implement, add this
 		{
 			writeVal = 0x03030303;
 		}
 		else
 		{
-			writeVal = (byte3<<24) | (byte2<<16) |(byte1<<8) |byte0;
+			writeVal = (byte3<<24) | (byte2<<16) | (byte1<<8) | byte0;
 		}
 		rtl8192_setBBreg(priv, RegOffset[index], 0x7f7f7f7f, writeVal);
 	}
@@ -300,7 +300,7 @@ static void r8192e_drain_tx_queues(struct r8192_priv *priv)
 	{
 		struct rtl8192_tx_ring *ring = &priv->tx_ring[QueueID];
 
-		if(skb_queue_len(&ring->queue) == 0)
+		if (skb_queue_len(&ring->queue) == 0)
 		{
 			QueueID++;
 			continue;
@@ -329,7 +329,7 @@ static bool SetRFPowerState8190(struct r8192_priv *priv,
 		goto out;
 	}
 
-	switch( eRFPowerState )
+	switch (eRFPowerState)
 	{
 	case eRfOn:
 
@@ -342,7 +342,7 @@ static bool SetRFPowerState8190(struct r8192_priv *priv,
 			 * is halting the NIC, re-initialize the NIC.
 			 */
 			if (!NicIFEnableNIC(priv)) {
-				RT_TRACE(COMP_ERR, "%s(): NicIFEnableNIC failed\n",__FUNCTION__);
+				RT_TRACE(COMP_ERR, "%s(): NicIFEnableNIC failed\n", __FUNCTION__);
 				bResult = false;
 				goto out;
 			}
@@ -380,7 +380,7 @@ static bool SetRFPowerState8190(struct r8192_priv *priv,
 	case eRfSleep:
 
 		// HW setting had been configured with deeper mode.
-		if(priv->eRFPowerState == eRfOff)
+		if (priv->eRFPowerState == eRfOff)
 			break;
 
 		r8192e_drain_tx_queues(priv);
@@ -416,7 +416,7 @@ static bool SetRFPowerState8190(struct r8192_priv *priv,
 		break;
 	}
 
-	if(bResult)
+	if (bResult)
 	{
 		// Update current RF state variable.
 		priv->eRFPowerState = eRFPowerState;
@@ -437,17 +437,17 @@ static void MgntDisconnectIBSS(struct r8192_priv *priv)
 
 	priv->ieee80211->state = IEEE80211_NOLINK;
 
-	for(i=0;i<6;i++)  priv->ieee80211->current_network.bssid[i]= 0x55;
+	for (i = 0; i < 6; i++)  priv->ieee80211->current_network.bssid[i]= 0x55;
 	priv->OpMode = RT_OP_MODE_NO_LINK;
-	write_nic_word(priv, BSSIDR, ((u16*)priv->ieee80211->current_network.bssid)[0]);
-	write_nic_dword(priv, BSSIDR+2, ((u32*)(priv->ieee80211->current_network.bssid+2))[0]);
+	write_nic_word(priv, BSSIDR, ((u16 *)priv->ieee80211->current_network.bssid)[0]);
+	write_nic_dword(priv, BSSIDR+2, ((u32 *)(priv->ieee80211->current_network.bssid+2))[0]);
 	{
 			RT_OP_MODE	OpMode = priv->OpMode;
 			u8	btMsr = read_nic_byte(priv, MSR);
 
 			btMsr &= 0xfc;
 
-			switch(OpMode)
+			switch (OpMode)
 			{
 			case RT_OP_MODE_INFRASTRUCTURE:
 				btMsr |= MSR_LINK_MANAGED;
@@ -500,14 +500,14 @@ static void MlmeDisassociateRequest(struct r8192_priv *priv, u8 *asSta,
 
 	RemovePeerTS(priv->ieee80211, asSta);
 
-	SendDisassociation( priv->ieee80211, asSta, asRsn );
+	SendDisassociation(priv->ieee80211, asSta, asRsn);
 
-	if(memcpy(priv->ieee80211->current_network.bssid,asSta,6) == NULL)
+	if (memcpy(priv->ieee80211->current_network.bssid, asSta, 6) == NULL)
 	{
 		//ShuChen TODO: change media status.
 		//ShuChen TODO: What to do when disassociate.
 		priv->ieee80211->state = IEEE80211_NOLINK;
-		for(i=0;i<6;i++)  priv->ieee80211->current_network.bssid[i] = 0x22;
+		for (i = 0; i < 6; i++)  priv->ieee80211->current_network.bssid[i] = 0x22;
 		priv->OpMode = RT_OP_MODE_NO_LINK;
 		{
 			RT_OP_MODE	OpMode = priv->OpMode;
@@ -515,7 +515,7 @@ static void MlmeDisassociateRequest(struct r8192_priv *priv, u8 *asSta,
 
 			btMsr &= 0xfc;
 
-			switch(OpMode)
+			switch (OpMode)
 			{
 			case RT_OP_MODE_INFRASTRUCTURE:
 				btMsr |= MSR_LINK_MANAGED;
@@ -539,8 +539,8 @@ static void MlmeDisassociateRequest(struct r8192_priv *priv, u8 *asSta,
 		}
 		ieee80211_disassociate(priv->ieee80211);
 
-		write_nic_word(priv, BSSIDR, ((u16*)priv->ieee80211->current_network.bssid)[0]);
-		write_nic_dword(priv, BSSIDR+2, ((u32*)(priv->ieee80211->current_network.bssid+2))[0]);
+		write_nic_word(priv, BSSIDR, ((u16 *)priv->ieee80211->current_network.bssid)[0]);
+		write_nic_dword(priv, BSSIDR+2, ((u32 *)(priv->ieee80211->current_network.bssid+2))[0]);
 
 	}
 
@@ -576,13 +576,13 @@ static void MgntDisconnectAP(struct r8192_priv *priv, u8 asRsn)
 static bool MgntDisconnect(struct r8192_priv *priv, u8 asRsn)
 {
 	// In adhoc mode, update beacon frame.
-	if( priv->ieee80211->state == IEEE80211_LINKED )
+	if (priv->ieee80211->state == IEEE80211_LINKED)
 	{
-		if( priv->ieee80211->iw_mode == IW_MODE_ADHOC )
+		if (priv->ieee80211->iw_mode == IW_MODE_ADHOC)
 		{
 			MgntDisconnectIBSS(priv);
 		}
-		if( priv->ieee80211->iw_mode == IW_MODE_INFRA )
+		if (priv->ieee80211->iw_mode == IW_MODE_INFRA)
 		{
 			// We clear key here instead of MgntDisconnectAP() because that
 			// MgntActSet_802_11_DISASSOCIATE() is an interface called by OS,
@@ -611,13 +611,13 @@ bool MgntActSet_RF_State(struct r8192_priv *priv, RT_RF_POWER_STATE StateToSet,
 	bool 			bConnectBySSID = false;
 	RT_RF_POWER_STATE	rtState;
 
-	RT_TRACE(COMP_POWER, "===>MgntActSet_RF_State(): StateToSet(%d)\n",StateToSet);
+	RT_TRACE(COMP_POWER, "===>MgntActSet_RF_State(): StateToSet(%d)\n", StateToSet);
 
 	spin_lock(&priv->rf_ps_lock);
 
 	rtState = priv->eRFPowerState;
 
-	switch(StateToSet)
+	switch (StateToSet)
 	{
 	case eRfOn:
 		priv->RfOffReason &= (~ChangeSource);
@@ -628,7 +628,7 @@ bool MgntActSet_RF_State(struct r8192_priv *priv, RT_RF_POWER_STATE StateToSet,
 			bActionAllowed = true;
 
 
-			if(rtState == eRfOff && ChangeSource >=RF_CHANGE_BY_HW )
+			if (rtState == eRfOff && ChangeSource >= RF_CHANGE_BY_HW)
 			{
 				bConnectBySSID = true;
 			}
-- 
1.7.1

