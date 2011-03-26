Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab1CZBTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:19:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44871 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755586Ab1CZBSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:18:35 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19cyeVb5wFc7fi5KkWPLXtNLG89d+0m92tXi0chI7
	NiVX5EpFGclDFD
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 02/27] staging/bcm: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:17:51 +0100
Message-Id: <1301102296-15565-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110314224746.GA21100@kroah.com>
References: <20110314224746.GA21100@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/bcm

WRONG -> RIGHT
accomodate  -> accommodate
occured     -> occurred
reci[e]ve   -> receive

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/bcm/Adapter.h                  |    2 +-
 drivers/staging/bcm/CmHost.c                   |    6 +++---
 drivers/staging/bcm/HostMIBSInterface.h        |    2 +-
 drivers/staging/bcm/IPv6Protocol.c             |    4 ++--
 drivers/staging/bcm/InterfaceIdleMode.c        |    4 ++--
 drivers/staging/bcm/InterfaceIsr.c             |    2 +-
 drivers/staging/bcm/InterfaceRx.c              |   10 +++++-----
 drivers/staging/bcm/Misc.c                     |    2 +-
 drivers/staging/bcm/PHSModule.c                |    2 +-
 drivers/staging/bcm/Qos.c                      |    2 +-
 drivers/staging/bcm/cntrl_SignalingInterface.h |    4 ++--
 11 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 32909e2..c37d795 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -412,7 +412,7 @@ struct _MINI_ADAPTER
 
 	// this to keep track of the Tx and Rx MailBox Registers.
 	atomic_t		    CurrNumFreeTxDesc;
-	// to keep track the no of byte recieved
+	// to keep track the no of byte received
 	USHORT				PrevNumRecvDescs;
 	USHORT				CurrNumRecvDescs;
 	UINT				u32TotalDSD;
diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 9be184f..f6e1b08 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1103,7 +1103,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  "u8TrafficIndicationPreference	: 0x%X",
 		pstAddIndication->sfAuthorizedSet.u8TrafficIndicationPreference);
 
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Recieved		: 0x%X",pstAddIndication->sfAuthorizedSet.u8TotalClassifiers);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Received		: 0x%X",pstAddIndication->sfAuthorizedSet.u8TotalClassifiers);
 
 	nCurClassifierCnt = pstAddIndication->sfAuthorizedSet.u8TotalClassifiers;
 
@@ -1305,7 +1305,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  "u8TrafficIndicationPreference	: 0x%02X",
 		pstAddIndication->sfAdmittedSet.u8TrafficIndicationPreference);
 
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Recieved		: 0x%X",pstAddIndication->sfAdmittedSet.u8TotalClassifiers);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Received		: 0x%X",pstAddIndication->sfAdmittedSet.u8TotalClassifiers);
 
 	nCurClassifierCnt = pstAddIndication->sfAdmittedSet.u8TotalClassifiers;
 
@@ -1502,7 +1502,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " u8TrafficIndicationPreference	: 0x%X",
 		pstAddIndication->sfActiveSet.u8TrafficIndicationPreference);
 
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Recieved		: 0x%X",pstAddIndication->sfActiveSet.u8TotalClassifiers);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Received		: 0x%X",pstAddIndication->sfActiveSet.u8TotalClassifiers);
 
 	nCurClassifierCnt = pstAddIndication->sfActiveSet.u8TotalClassifiers;
 
diff --git a/drivers/staging/bcm/HostMIBSInterface.h b/drivers/staging/bcm/HostMIBSInterface.h
index f17a4f1..e34531b 100644
--- a/drivers/staging/bcm/HostMIBSInterface.h
+++ b/drivers/staging/bcm/HostMIBSInterface.h
@@ -62,7 +62,7 @@ typedef struct _S_MIBS_HOST_INFO
 	ULONG			NumDesUsed;
 	ULONG			CurrNumFreeDesc;
 	ULONG			PrevNumFreeDesc;
-	// to keep track the no of byte recieved
+	// to keep track the no of byte received
 	ULONG			PrevNumRcevBytes;
 	ULONG			CurrNumRcevBytes;
 
diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index 91b6fbe..5b4fd37 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -287,7 +287,7 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Head
 
 	for(uiLoopIndex=0;uiLoopIndex<uiCountIPSrcAddresses;uiLoopIndex+=uiIpv6AddrNoLongWords)
 	{
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Recieved Packet : \n ");
+		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Address In Received Packet : \n ");
 		DumpIpv6Address(aulSrcIP);
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Src Ipv6 Mask In Classifier Rule: \n");
 		DumpIpv6Address(&pstClassifierRule->stSrcIpAddress.ulIpv6Mask[uiLoopIndex]);
@@ -340,7 +340,7 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,IPV6Hea
 
 	for(uiLoopIndex=0;uiLoopIndex<uiCountIPDestinationAddresses;uiLoopIndex+=uiIpv6AddrNoLongWords)
 	{
-		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Recieved Packet : \n ");
+		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Address In Received Packet : \n ");
 		DumpIpv6Address(aulDestIP);
 		BCM_DEBUG_PRINT( Adapter,DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL, "\n Destination Ipv6 Mask In Classifier Rule: \n");
 		DumpIpv6Address(&pstClassifierRule->stDestIpAddress.ulIpv6Mask[uiLoopIndex]);
diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
index bf5c0ad..96fa4ea 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -11,7 +11,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				BCM_STATUS_SUCCESS - If Wakeup of the HW Interface was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 
 
@@ -26,7 +26,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				BCM_STATUS_SUCCESS - If Idle mode response related HW configuration was successful.
-						Other           - If an error occured.
+						Other           - If an error occurred.
 */
 
 /*
diff --git a/drivers/staging/bcm/InterfaceIsr.c b/drivers/staging/bcm/InterfaceIsr.c
index 220ff92..6dd5d9e 100644
--- a/drivers/staging/bcm/InterfaceIsr.c
+++ b/drivers/staging/bcm/InterfaceIsr.c
@@ -81,7 +81,7 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
 		case -EINPROGRESS:
 		{
 			//This situation may happend when URBunlink is used. for detail check usb_unlink_urb documentation.
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Impossibe condition has occured... something very bad is going on");
+			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Impossibe condition has occurred... something very bad is going on");
 			break ;
 			//return;
 		}
diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index 533f8eb..4a42cb4 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -123,7 +123,7 @@ static void read_bulk_callback(struct urb *urb)
 	if((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
 	    (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
 	{
-	    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Recived control pkt...");
+	    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
 		*(PUSHORT)skb->data = pLeader->Status;
        	memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
 			(sizeof(LEADER)), pLeader->PLength);
@@ -142,7 +142,7 @@ static void read_bulk_callback(struct urb *urb)
 		  * Data Packet, Format a proper Ethernet Header
         	  * and give it to the stack
 		  */
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Recived Data pkt...");
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt...");
 		skb_reserve(skb, 2 + SKB_RESERVE_PHS_BYTES);
 		memcpy(skb->data+ETH_HLEN, (PUCHAR)urb->transfer_buffer + sizeof(LEADER), pLeader->PLength);
 		skb->dev = Adapter->dev;
@@ -151,7 +151,7 @@ static void read_bulk_callback(struct urb *urb)
 		skb_put (skb, pLeader->PLength + ETH_HLEN);
 		Adapter->PackInfo[QueueIndex].uiTotalRxBytes+=pLeader->PLength;
 		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes+= pLeader->PLength;
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Recived Data pkt of len :0x%X", pLeader->PLength);
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
 
 		if(netif_running(Adapter->dev))
 		{
@@ -229,7 +229,7 @@ static int ReceiveRcb(PS_INTERFACE_ADAPTER psIntfAdapter, PUSB_RCB pRcb)
 /*
 Function:				InterfaceRx
 
-Description:			This is the hardware specific Function for Recieveing
+Description:			This is the hardware specific Function for Receiveing
 						data packet/control packets from the device.
 
 Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
@@ -237,7 +237,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
 
 
 Return:				TRUE  - If Rx was successful.
-					Other - If an error occured.
+					Other - If an error occurred.
 */
 
 BOOLEAN InterfaceRx (PS_INTERFACE_ADAPTER psIntfAdapter)
diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index d624f35..4d2ed16 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -602,7 +602,7 @@ VOID LinkControlResponseMessage(PMINI_ADAPTER Adapter,PUCHAR pucBuffer)
 				Adapter->LinkStatus=LINKUP_DONE;
 				Adapter->bPHSEnabled = *(pucBuffer+3);
                	Adapter->bETHCSEnabled = *(pucBuffer+4) & ETH_CS_MASK;
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "PHS Support Status Recieved In LinkUp Ack : %x \n",Adapter->bPHSEnabled);
+				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "PHS Support Status Received In LinkUp Ack : %x \n",Adapter->bPHSEnabled);
 				if((FALSE == Adapter->bShutStatus)&&
 					(FALSE == Adapter->IdleMode))
 				{
diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
index d1ca191..c028175 100644
--- a/drivers/staging/bcm/PHSModule.c
+++ b/drivers/staging/bcm/PHSModule.c
@@ -66,7 +66,7 @@ Input parameters:		IN PMINI_ADAPTER Adapter         - Miniport Adapter Context
 						BOOLEAN bHeaderSuppressionEnabled - indicates if header suprression is enabled for SF.
 
 Return:					STATUS_SUCCESS - If the send was successful.
-						Other          - If an error occured.
+						Other          - If an error occurred.
 */
 
 int PHSTransmit(PMINI_ADAPTER Adapter,
diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index feade94..c97020f 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -727,7 +727,7 @@ static BOOLEAN EthCSMatchVLANRules(S_CLASSIFIER_RULE *pstClassifierRule,struct s
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n",__FUNCTION__,ntohs(*((USHORT *)pstClassifierRule->usUserPriority)),pstClassifierRule->usVLANID);
 
-	/* In case FW didn't recieve the TLV, the priority field should be ignored */
+	/* In case FW didn't receive the TLV, the priority field should be ignored */
 	if(pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID))
 	{
 		if(pstEthCsPktInfo->eNwpktEthFrameType!=eEth802QVLANFrame)
diff --git a/drivers/staging/bcm/cntrl_SignalingInterface.h b/drivers/staging/bcm/cntrl_SignalingInterface.h
index 8907784..67bb2f5 100644
--- a/drivers/staging/bcm/cntrl_SignalingInterface.h
+++ b/drivers/staging/bcm/cntrl_SignalingInterface.h
@@ -21,8 +21,8 @@
 #define VENDOR_PHS_PARAM_LENGTH 10
 #define MAX_NUM_ACTIVE_BS 10
 #define AUTH_TOKEN_LENGTH	10
-#define NUM_HARQ_CHANNELS	16	//Changed from 10 to 16 to accomodate all HARQ channels
-#define VENDOR_CLASSIFIER_PARAM_LENGTH 1 //Changed the size to 1 byte since we dnt use it
+#define NUM_HARQ_CHANNELS	16	//Changed from 10 to 16 to accommodate all HARQ channels
+#define VENDOR_CLASSIFIER_PARAM_LENGTH 1 //Changed the size to 1 byte since we dont use it
 #define  VENDOR_SPECIF_QOS_PARAM 1
 #define VENDOR_PHS_PARAM_LENGTH	10
 #define MBS_CONTENTS_ID_LENGTH	10
-- 
1.7.3.4

