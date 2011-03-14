Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab1CNV6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:58:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58325 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751983Ab1CNV6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:58:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18MG0Ae8JsM69mN3HO2wyMSE/mU76Lr86ZRtNxsTV
	2XIuese2lbROim
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <gregkh@suse.de>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/trivial: Fix common spelling mistakes
Date: Mon, 14 Mar 2011 22:57:55 +0100
Message-Id: <1300139875-8688-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <alpine.LNX.2.00.1103141259500.19969@pobox.suse.cz>
References: <alpine.LNX.2.00.1103141259500.19969@pobox.suse.cz>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in drivers/staging
The changes were carried out by hand and are made in
documentation/comments only - no functional change.
Variables were left untouched on purpose.
Linebreaks were also left untouched on purpose.

The fixed spelling mistakes are:
WRONG -> RIGHT

accomodate -> accommodate
acommodate -> accommodate

adress -> address
addres -> address

hightest -> highest
hight -> height
hight -> high (when mentioned in contrast to low)
hightlight -> highlight

libary -> library
libaray -> library

occured -> occurred

reqest -> request
reguest -> request
requst -> request
reqeust -> request

acheive -> achieve
beggining -> beginning
embarass -> embarrass
enviroment -> environment
fagment -> fragment
indefinately-> indefinitely
knowlege -> knowledge
regester -> register
unferflow -> underflow

recieve -> receive

interupt -> interrupt
interrrupt -> interrupt

paralell -> parallel
paralel -> parallel
preceeding -> preceding
publically -> publicly
shedule -> shedule
supercede -> supersede
wierd -> weird
writen -> written
writting -> writing

And some other minor changes that caught my eye doing the changes

KernelVersion: Linux-next of 20110314 (c0ebee1a2)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    4 +-
 drivers/staging/ath6kl/include/common/a_hci.h      |    2 +-
 drivers/staging/ath6kl/include/common/wmi.h        |    2 +-
 drivers/staging/ath6kl/include/htc_api.h           |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
 drivers/staging/bcm/Adapter.h                      |    2 +-
 drivers/staging/bcm/CmHost.c                       |    6 ++--
 drivers/staging/bcm/HostMIBSInterface.h            |    2 +-
 drivers/staging/bcm/IPv6Protocol.c                 |    4 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |    4 +-
 drivers/staging/bcm/InterfaceIsr.c                 |    2 +-
 drivers/staging/bcm/InterfaceRx.c                  |   10 ++++----
 drivers/staging/bcm/Misc.c                         |    2 +-
 drivers/staging/bcm/PHSModule.c                    |    2 +-
 drivers/staging/bcm/Qos.c                          |    2 +-
 drivers/staging/bcm/cntrl_SignalingInterface.h     |    4 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    2 +-
 drivers/staging/brcm80211/include/bcmsrom_fmt.h    |    4 +-
 drivers/staging/comedi/comedi_fops.c               |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    8 +++---
 drivers/staging/comedi/drivers/adv_pci1710.c       |    2 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |    2 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |    4 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    4 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |    6 ++--
 drivers/staging/comedi/drivers/s626.c              |   12 ++++----
 drivers/staging/comedi/drivers/unioxx5.c           |    4 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |    2 +-
 drivers/staging/dt3155v4l/dt3155v4l.c              |    6 ++--
 drivers/staging/easycap/README                     |    2 +-
 drivers/staging/easycap/easycap_low.c              |    2 +-
 drivers/staging/et131x/et1310_rx.c                 |    2 +-
 drivers/staging/et131x/et131x_isr.c                |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    4 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    2 +-
 drivers/staging/iio/Documentation/iio_utils.h      |    2 +-
 drivers/staging/iio/accel/adis16201.h              |    2 +-
 drivers/staging/iio/accel/adis16203.h              |    2 +-
 drivers/staging/iio/accel/adis16204.h              |    2 +-
 drivers/staging/iio/accel/adis16209.h              |    2 +-
 drivers/staging/iio/accel/adis16220.h              |    2 +-
 drivers/staging/iio/accel/adis16240.h              |    2 +-
 drivers/staging/iio/accel/lis3l02dq.h              |   26 ++++++++++----------
 drivers/staging/iio/accel/lis3l02dq_core.c         |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    4 +-
 drivers/staging/iio/accel/sca3000.h                |    2 +-
 drivers/staging/iio/adc/max1363_core.c             |    2 +-
 drivers/staging/iio/chrdev.h                       |    2 +-
 drivers/staging/iio/gyro/adis16060_core.c          |    2 +-
 drivers/staging/iio/gyro/adis16080_core.c          |    2 +-
 drivers/staging/iio/gyro/adis16260.h               |    2 +-
 drivers/staging/iio/iio.h                          |    2 +-
 drivers/staging/iio/imu/adis16300.h                |    2 +-
 drivers/staging/iio/imu/adis16350.h                |    2 +-
 drivers/staging/iio/imu/adis16400.h                |    2 +-
 drivers/staging/iio/meter/ade7753.h                |    2 +-
 drivers/staging/iio/meter/ade7754.h                |    2 +-
 drivers/staging/iio/meter/ade7758.h                |    2 +-
 drivers/staging/iio/meter/ade7759.h                |    2 +-
 drivers/staging/iio/meter/ade7854.h                |    2 +-
 .../staging/intel_sst/intel_sst_app_interface.c    |   14 +++++-----
 drivers/staging/intel_sst/intel_sst_dsp.c          |    2 +-
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    2 +-
 drivers/staging/lirc/lirc_ene0100.h                |    2 +-
 drivers/staging/octeon/cvmx-helper.c               |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c         |    2 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    8 +++---
 drivers/staging/rt2860/common/action.c             |    2 +-
 drivers/staging/rt2860/common/ba_action.c          |    4 +-
 drivers/staging/rt2860/common/cmm_data_usb.c       |    2 +-
 drivers/staging/rt2860/sta/connect.c               |    2 +-
 drivers/staging/sbe-2t3e3/io.c                     |    4 +-
 drivers/staging/sep/sep_driver.c                   |    2 +-
 drivers/staging/spectra/flash.c                    |    2 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |    2 +-
 drivers/staging/tidspbridge/hw/hw_mmu.c            |    6 ++--
 .../staging/tidspbridge/include/dspbridge/clk.h    |    6 ++--
 .../staging/tidspbridge/include/dspbridge/cmm.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/cod.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/dev.h    |    2 +-
 .../tidspbridge/include/dspbridge/dspdefs.h        |   14 +++++-----
 .../staging/tidspbridge/include/dspbridge/mgr.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/node.h   |    2 +-
 .../staging/tidspbridge/include/dspbridge/proc.h   |    6 ++--
 .../staging/tidspbridge/include/dspbridge/pwr.h    |    8 +++---
 drivers/staging/vme/bridges/vme_tsi148.h           |    8 +++---
 drivers/staging/vt6655/device_main.c               |    2 +-
 drivers/staging/vt6655/tether.h                    |    4 +-
 drivers/staging/vt6656/baseband.c                  |    2 +-
 .../westbridge/astoria/api/src/cyaslowlevel.c      |    2 +-
 .../staging/westbridge/astoria/api/src/cyasmisc.c  |    4 +-
 .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
 .../westbridge/astoria/block/cyasblkdev_queue.c    |    2 +-
 .../astoria/include/linux/westbridge/cyasstorage.h |   22 ++++++++--------
 .../astoria/include/linux/westbridge/cyasusb_dep.h |    2 +-
 drivers/staging/wlags49_h2/hcf.c                   |    2 +-
 drivers/staging/wlags49_h2/mdd.h                   |    2 +-
 drivers/staging/wlan-ng/p80211req.c                |    2 +-
 101 files changed, 183 insertions(+), 183 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index 3ee3d40..0ae721b 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -285,7 +285,7 @@ static void FailureCallback(void *pContext, int Status)
 {
     GMBOX_PROTO_HCI_UART  *pProt = (GMBOX_PROTO_HCI_UART *)pContext; 
     
-        /* target assertion occured */           
+        /* target assertion occurred */
     NotifyTransportFailure(pProt, Status);  
 }
 
@@ -507,7 +507,7 @@ static int HCIUartMessagePending(void *pContext, u8 LookAheadBytes[], int ValidB
         
     } while (false);
         
-        /* check if we need to disable the reciever */
+        /* check if we need to disable the receiver */
     if (status || blockRecv) {
         DevGMboxIRQAction(pProt->pDev, GMBOX_RECV_IRQ_DISABLE, PROC_IO_SYNC); 
     }
diff --git a/drivers/staging/ath6kl/include/common/a_hci.h b/drivers/staging/ath6kl/include/common/a_hci.h
index 08cb013..fcfbb00 100644
--- a/drivers/staging/ath6kl/include/common/a_hci.h
+++ b/drivers/staging/ath6kl/include/common/a_hci.h
@@ -430,7 +430,7 @@ typedef struct  hci_event_hw_err_t {
     u8 hw_err_code;
 } POSTPACK HCI_EVENT_HW_ERR;
 
-/* Flush occured event */
+/* Flush occurred event */
 /* Qos Violation event */
 typedef struct  hci_event_handle_t {
     u8 event_code;
diff --git a/drivers/staging/ath6kl/include/common/wmi.h b/drivers/staging/ath6kl/include/common/wmi.h
index c645af3..ee0b386 100644
--- a/drivers/staging/ath6kl/include/common/wmi.h
+++ b/drivers/staging/ath6kl/include/common/wmi.h
@@ -2084,7 +2084,7 @@ typedef PREPACK struct {
 /*
  * BSS INFO HDR version 2.0
  * With 6 bytes HTC header and 6 bytes of WMI header
- * WMI_BSS_INFO_HDR cannot be accomodated in the removed 802.11 management
+ * WMI_BSS_INFO_HDR cannot be accommodated in the removed 802.11 management
  * header space.
  * - Reduce the ieMask to 2 bytes as only two bit flags are used
  * - Remove rssi and compute it on the host. rssi = snr - 95
diff --git a/drivers/staging/ath6kl/include/htc_api.h b/drivers/staging/ath6kl/include/htc_api.h
index c5c9fed..5147389 100644
--- a/drivers/staging/ath6kl/include/htc_api.h
+++ b/drivers/staging/ath6kl/include/htc_api.h
@@ -209,7 +209,7 @@ typedef struct _HTC_ENDPOINT_CREDIT_DIST {
 typedef enum _HTC_CREDIT_DIST_REASON {
     HTC_CREDIT_DIST_SEND_COMPLETE = 0,     /* credits available as a result of completed
                                               send operations (MANDATORY) resulting in credit reports */
-    HTC_CREDIT_DIST_ACTIVITY_CHANGE = 1,   /* a change in endpoint activity occured (OPTIONAL) */
+    HTC_CREDIT_DIST_ACTIVITY_CHANGE = 1,   /* a change in endpoint activity occurred (OPTIONAL) */
     HTC_CREDIT_DIST_SEEK_CREDITS,          /* an endpoint needs to "seek" credits (OPTIONAL) */
     HTC_DUMP_CREDIT_STATE                  /* for debugging, dump any state information that is kept by
                                               the distribution function */
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 811235a..3737165 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -520,7 +520,7 @@ dbglog_parse_debug_logs(s8 *datap, u32 len)
 int
 ar6000_dbglog_get_debug_logs(AR_SOFTC_T *ar)
 {
-    u32 data[8]; /* Should be able to accomodate struct dbglog_buf_s */
+    u32 data[8]; /* Should be able to accommodate struct dbglog_buf_s */
     u32 address;
     u32 length;
     u32 dropped;
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
index 017b471..920532e 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1107,7 +1107,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  "u8TrafficIndicationPreference	: 0x%X",
 		pstAddIndication->sfAuthorizedSet.u8TrafficIndicationPreference);
 
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Recieved		: 0x%X",pstAddIndication->sfAuthorizedSet.u8TotalClassifiers);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Received		: 0x%X",pstAddIndication->sfAuthorizedSet.u8TotalClassifiers);
 
 	nCurClassifierCnt = pstAddIndication->sfAuthorizedSet.u8TotalClassifiers;
 
@@ -1309,7 +1309,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  "u8TrafficIndicationPreference	: 0x%02X",
 		pstAddIndication->sfAdmittedSet.u8TrafficIndicationPreference);
 
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Recieved		: 0x%X",pstAddIndication->sfAdmittedSet.u8TotalClassifiers);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL,  " Total Classifiers Received		: 0x%X",pstAddIndication->sfAdmittedSet.u8TotalClassifiers);
 
 	nCurClassifierCnt = pstAddIndication->sfAdmittedSet.u8TotalClassifiers;
 
@@ -1506,7 +1506,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
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
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 65313fa..71c3571 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -264,7 +264,7 @@ extern SDIOH_API_RC sdioh_disable_func_intr(void)
 }
 #endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
 
-/* Configure callback to client when we recieve client interrupt */
+/* Configure callback to client when we receive client interrupt */
 extern SDIOH_API_RC
 sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 7f8790d..4014c00 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -407,7 +407,7 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 		/*
 		   compute a new dma xfer rate for max_mpdu @ max mcs.
 		   This is the minimum dma rate that
-		   can acheive no unferflow condition for the current mpdu size.
+		   can achieve no underflow condition for the current mpdu size.
 		 */
 		/* note : we divide/multiply by 100 to avoid integer overflows */
 		fifo->dmaxferrate =
diff --git a/drivers/staging/brcm80211/include/bcmsrom_fmt.h b/drivers/staging/brcm80211/include/bcmsrom_fmt.h
index ae2bff8..4666afd 100644
--- a/drivers/staging/brcm80211/include/bcmsrom_fmt.h
+++ b/drivers/staging/brcm80211/include/bcmsrom_fmt.h
@@ -103,9 +103,9 @@
 
 #define	SROM_CRCREV		63
 
-/* SROM Rev 4: Reallocate the software part of the srom to accomodate
+/* SROM Rev 4: Reallocate the software part of the srom to accommodate
  * MIMO features. It assumes up to two PCIE functions and 440 bytes
- * of useable srom i.e. the useable storage in chips with OTP that
+ * of usable srom i.e. the usable storage in chips with OTP that
  * implements hardware redundancy.
  */
 
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index a4ceb29..e7e72b8 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2064,7 +2064,7 @@ void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 			     COMEDI_CB_OVERFLOW)) {
 		runflags_mask |= SRF_RUNNING;
 	}
-	/* remember if an error event has occured, so an error
+	/* remember if an error event has occurred, so an error
 	 * can be returned the next time the user does a read() */
 	if (s->async->events & (COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) {
 		runflags_mask |= SRF_ERROR;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
index 9dd857d..f5b8521 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
@@ -488,9 +488,9 @@ int i_APCI2032_ReadWatchdog(struct comedi_device *dev, struct comedi_subdevice *
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
+| Return Value      : TRUE  : No error occurred                              |
+|		            : FALSE : Error occurred. Return the error               |
+|			                                                                 |
 +----------------------------------------------------------------------------+
 */
 void v_APCI2032_Interrupt(int irq, void *d)
@@ -498,7 +498,7 @@ void v_APCI2032_Interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	unsigned int ui_DO;
 
-	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occured. */
+	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occurred. */
 
 	if (ui_DO == 0) {
 		printk("\nInterrupt from unKnown source\n");
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 466e69f..0fd0ac5 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -98,7 +98,7 @@ Configuration options:
 #define	Status_FE	0x0100	/* 1=FIFO is empty */
 #define Status_FH	0x0200	/* 1=FIFO is half full */
 #define Status_FF	0x0400	/* 1=FIFO is full, fatal error */
-#define Status_IRQ	0x0800	/* 1=IRQ occured */
+#define Status_IRQ	0x0800	/* 1=IRQ occurred */
 /* bits from control register (PCI171x_CONTROL) */
 #define Control_CNT0	0x0040	/* 1=CNT0 have external source,
 				 * 0=have internal 100kHz source */
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 0941643..f1824eb 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -440,7 +440,7 @@ struct cb_pcidas_private {
 	unsigned int divisor1;
 	unsigned int divisor2;
 	volatile unsigned int count;	/*  number of analog input samples remaining */
-	volatile unsigned int adc_fifo_bits;	/*  bits to write to interupt/adcfifo register */
+	volatile unsigned int adc_fifo_bits;	/*  bits to write to interrupt/adcfifo register */
 	volatile unsigned int s5933_intcsr_bits;	/*  bits to write to amcc s5933 interrupt control/status register */
 	volatile unsigned int ao_control_bits;	/*  bits to write to ao control and status register */
 	short ai_buffer[AI_BUFFER_SIZE];
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index b220b30..a804742 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -81,7 +81,7 @@ static const struct waveform_board waveform_boards[] = {
 /* Data unique to this driver */
 struct waveform_private {
 	struct timer_list timer;
-	struct timeval last;	/* time at which last timer interrupt occured */
+	struct timeval last;	/* time at which last timer interrupt occurred */
 	unsigned int uvolt_amplitude;	/* waveform amplitude in microvolts */
 	unsigned long usec_period;	/* waveform period in microseconds */
 	unsigned long usec_current;	/* current time (modulo waveform period) */
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 75511ba..b692fea 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1810,7 +1810,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		       ai_context->irq_status_reg) &
 	    ME4000_IRQ_STATUS_BIT_AI_HF) {
 		ISR_PDEBUG
-		    ("me4000_ai_isr(): Fifo half full interrupt occured\n");
+		    ("me4000_ai_isr(): Fifo half full interrupt occurred\n");
 
 		/* Read status register to find out what happened */
 		tmp = me4000_inl(dev, ai_context->ctrl_reg);
@@ -1903,7 +1903,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 	if (me4000_inl(dev,
 		       ai_context->irq_status_reg) & ME4000_IRQ_STATUS_BIT_SC) {
 		ISR_PDEBUG
-		    ("me4000_ai_isr(): Sample counter interrupt occured\n");
+		    ("me4000_ai_isr(): Sample counter interrupt occurred\n");
 
 		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOA;
 
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index e46d62b..e8755d7 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -106,8 +106,8 @@ TRIG_WAKE_EOS
 #define   OVFL_BIT		0x8	/*  fifo overflow */
 #define   EDAQ_BIT		0x10	/*  end of aquisition interrupt */
 #define   DCAL_BIT		0x20	/*  offset calibration in progress */
-#define   INTR_BIT		0x40	/*  interrupt has occured */
-#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occured */
+#define   INTR_BIT		0x40	/*  interrupt has occurred */
+#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occurred */
 #define   ID_BITS(x)	(((x) >> 8) & 0x3)
 #define IRQ_DMA_CNTRL_REG		0x12	/*  write only */
 #define   DMA_CHAN_BITS(x)		((x) & 0x7)	/*  sets dma channel */
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 0728c3c..4641e03 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -183,11 +183,11 @@ NI manuals:
 #define   OVERRUN_BIT	0x2
 /* fifo overflow */
 #define   OVERFLOW_BIT	0x4
-/* timer interrupt has occured */
+/* timer interrupt has occurred */
 #define   TIMER_BIT	0x8
-/* dma terminal count has occured */
+/* dma terminal count has occurred */
 #define   DMATC_BIT	0x10
-/* external trigger has occured */
+/* external trigger has occurred */
 #define   EXT_TRIG_BIT	0x40
 /* 1200 boards only */
 #define STATUS2_REG	0x1d
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d5ba3ab..0f9aa01 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1048,7 +1048,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 	uint8_t group;
 	uint16_t irqbit;
 
-	DEBUG("s626_irq_handler: interrupt request recieved!!!\n");
+	DEBUG("s626_irq_handler: interrupt request received!!!\n");
 
 	if (dev->attached == 0)
 		return IRQ_NONE;
@@ -1165,7 +1165,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 							(16 * group)))
 					    == 1 && cmd->start_src == TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->start_arg);
 
 						/*  Start executing the RPS program. */
@@ -1194,7 +1194,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					    && cmd->scan_begin_src ==
 					    TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->scan_begin_arg);
 
 						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
@@ -1236,7 +1236,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					    == 1
 					    && cmd->convert_src == TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->convert_arg);
 
 						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
@@ -1805,7 +1805,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		DEBUG("s626_ai_cmd: NULL command\n");
 		return -EINVAL;
 	} else {
-		DEBUG("s626_ai_cmd: command recieved!!!\n");
+		DEBUG("s626_ai_cmd: command received!!!\n");
 	}
 
 	if (dev->irq == 0) {
@@ -2570,7 +2570,7 @@ static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
 	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY)
 		;
 
-	/*  Return non-zero if I2C error occured. */
+	/*  Return non-zero if I2C error occurred. */
 	return RR7146(P_I2CCTRL) & I2C_ERR;
 
 }
diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 598884e..a69e450 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -314,7 +314,7 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 		outb(i + 1, subdev_iobase + 5);	/* sends channel number to card */
 		outb('H', subdev_iobase + 6);	/* requests EEPROM world */
 		while (!(inb(subdev_iobase + 0) & TxBE))
-			;	/* waits while writting will be allowed */
+			;	/* waits while writing will be allowed */
 		outb(0, subdev_iobase + 6);
 
 		/* waits while reading of two bytes will be allowed */
@@ -450,7 +450,7 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 	/* sending for bytes to module(one byte per cycle iteration) */
 	for (i = 0; i < 4; i++) {
 		while (!((inb(usp->usp_iobase + 0)) & TxBE))
-			;	/* waits while writting will be allowed */
+			;	/* waits while writing will be allowed */
 		outb(usp->usp_extra_data[module][i], usp->usp_iobase + 6);
 	}
 
diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 153ddbf..018041d 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -2366,7 +2366,7 @@ enum BC_STATUS crystalhd_hw_set_core_clock(struct crystalhd_hw *hw)
 	BCMLOG(BCMLOG_INFO, "clock is moving to %d with n %d with vco_mg %d\n",
 	       hw->core_clock_mhz, n, vco_mg);
 
-	/* Change the DRAM refresh rate to accomodate the new frequency */
+	/* Change the DRAM refresh rate to accommodate the new frequency */
 	/* refresh reg = ((refresh_rate * clock_rate)/16) - 1; rounding up*/
 	refresh_reg = (7 * hw->core_clock_mhz / 16);
 	bc_dec_reg_wr(hw->adp, SDRAM_REF_PARAM, ((1 << 12) | refresh_reg));
diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
index 15d7efe..52a0e6e 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@ -122,7 +122,7 @@ read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
  *
  * returns:	zero on success or error code
  *
- * This function starts writting the specified (by index) register
+ * This function starts writing the specified (by index) register
  * and busy waits for the process to finish.
  */
 static int
@@ -155,7 +155,7 @@ write_i2c_reg(void __iomem *addr, u8 index, u8 data)
  * @index:	index (internal address) of register to read
  * @data:	data to be written
  *
- * This function starts writting the specified (by index) register
+ * This function starts writing the specified (by index) register
  * and then returns.
  */
 static void write_i2c_reg_nowait(void __iomem *addr, u8 index, u8 data)
@@ -173,7 +173,7 @@ static void write_i2c_reg_nowait(void __iomem *addr, u8 index, u8 data)
  *
  * returns:	zero on success or error code
  *
- * This function waits reading/writting to finish.
+ * This function waits reading/writing to finish.
  */
 static int wait_i2c_reg(void __iomem *addr)
 {
diff --git a/drivers/staging/easycap/README b/drivers/staging/easycap/README
index 6b5ac0d..ca53165 100644
--- a/drivers/staging/easycap/README
+++ b/drivers/staging/easycap/README
@@ -155,7 +155,7 @@ options easycap  gain=16 bars=1
 install easycap /sbin/rmmod snd-usb-audio; /sbin/modprobe --ignore-install easycap
 
 
-ACKNOWLEGEMENTS AND REFERENCES
+ACKNOWLEDGEMENTS AND REFERENCES
 ------------------------------
 This driver makes use of information contained in the Syntek Semicon DC-1125
 Driver, presently maintained at http://sourceforge.net/projects/syntekdriver/
diff --git a/drivers/staging/easycap/easycap_low.c b/drivers/staging/easycap/easycap_low.c
index 0385735..782a05e 100644
--- a/drivers/staging/easycap/easycap_low.c
+++ b/drivers/staging/easycap/easycap_low.c
@@ -27,7 +27,7 @@
 */
 /*****************************************************************************/
 /*
- *  ACKNOWLEGEMENTS AND REFERENCES
+ *  ACKNOWLEDGEMENTS AND REFERENCES
  *  ------------------------------
  *  This driver makes use of register information contained in the Syntek
  *  Semicon DC-1125 driver hosted at
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 339136f..fc6bd43 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -122,7 +122,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * number of entries in FBR1.
 	 *
 	 * FBR1 holds "large" frames, FBR0 holds "small" frames.  If FBR1
-	 * entries are huge in order to accomodate a "jumbo" frame, then it
+	 * entries are huge in order to accommodate a "jumbo" frame, then it
 	 * will have less entries.  Conversely, FBR1 will now be relied upon
 	 * to carry more "normal" frames, thus it's entry size also increases
 	 * and the number of entries goes up too (since it now carries
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index ce4d930..f716e40 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -466,7 +466,7 @@ void et131x_isr_handler(struct work_struct *work)
 		/* Handle SLV Timeout Interrupt */
 		if (status & ET_INTR_SLV_TIMEOUT) {
 			/*
-			 * This means a timeout has occured on a read or
+			 * This means a timeout has occurred on a read or
 			 * write request to one of the JAGCore registers. The
 			 * Global Resources block has terminated the request
 			 * and on a read request, returned a "fake" value.
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index ff691d9..ac2ab53 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -390,10 +390,10 @@ static void ft1000_reset_asic(struct net_device *dev)
 	}
 	mdelay(1);
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		// set watermark to -1 in order to not generate an interrrupt
+		// set watermark to -1 in order to not generate an interrupt
 		ft1000_write_reg(dev, FT1000_REG_WATERMARK, 0xffff);
 	} else {
-		// set watermark to -1 in order to not generate an interrrupt
+		// set watermark to -1 in order to not generate an interrupt
 		ft1000_write_reg(dev, FT1000_REG_MAG_WATERMARK, 0xffff);
 	}
 	// clear interrupts
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index e3b9934..96dd531 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -270,7 +270,7 @@ int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 // Parameters:  ft1000_device  - device structure
 //              indx - starting address to write the data
 //              value - 16bits value to write
-//              hightlow - high or low 16 bit word
+//              highlow - high or low 16 bit word
 //
 // Returns:     STATUS_SUCCESS - success
 //              STATUS_FAILURE - failure
@@ -610,7 +610,7 @@ static void ft1000_reset_asic (struct net_device *dev)
 
     mdelay(1);
 
-    // set watermark to -1 in order to not generate an interrrupt
+    // set watermark to -1 in order to not generate an interrupt
     ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
 
     // clear interrupts
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 88183fe..d2b6bc5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -364,7 +364,7 @@ struct prov_record {
 
 #define ISR_EMPTY			(u8)0x00 	 // no bits set in ISR
 
-#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been recieved.
+#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been received.
 
 #define ISR_DOORBELL_PEND	(u8)0x02 	 //  doorbell for me
 
diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
index 8095727..fd78e4f 100644
--- a/drivers/staging/iio/Documentation/iio_utils.h
+++ b/drivers/staging/iio/Documentation/iio_utils.h
@@ -556,7 +556,7 @@ int _write_sysfs_string(char *filename, char *basedir, char *val, int verify)
 		if (strcmp(temp, val) != 0) {
 			printf("Possible failure in string write of %s "
 				"Should be %s "
-				"writen to %s\%s\n",
+				"written to %s\%s\n",
 				temp,
 				val,
 				basedir,
diff --git a/drivers/staging/iio/accel/adis16201.h b/drivers/staging/iio/accel/adis16201.h
index c9bf22c..23fe54d 100644
--- a/drivers/staging/iio/accel/adis16201.h
+++ b/drivers/staging/iio/accel/adis16201.h
@@ -70,7 +70,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16201_state {
diff --git a/drivers/staging/iio/accel/adis16203.h b/drivers/staging/iio/accel/adis16203.h
index b39323e..b886881 100644
--- a/drivers/staging/iio/accel/adis16203.h
+++ b/drivers/staging/iio/accel/adis16203.h
@@ -65,7 +65,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16203_state {
diff --git a/drivers/staging/iio/accel/adis16204.h b/drivers/staging/iio/accel/adis16204.h
index e9ed7cb..e618446 100644
--- a/drivers/staging/iio/accel/adis16204.h
+++ b/drivers/staging/iio/accel/adis16204.h
@@ -73,7 +73,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16204_state {
diff --git a/drivers/staging/iio/accel/adis16209.h b/drivers/staging/iio/accel/adis16209.h
index 4e97596..8b0da13 100644
--- a/drivers/staging/iio/accel/adis16209.h
+++ b/drivers/staging/iio/accel/adis16209.h
@@ -109,7 +109,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16209_state {
diff --git a/drivers/staging/iio/accel/adis16220.h b/drivers/staging/iio/accel/adis16220.h
index 7013314..4d5758c 100644
--- a/drivers/staging/iio/accel/adis16220.h
+++ b/drivers/staging/iio/accel/adis16220.h
@@ -132,7 +132,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16220_state {
diff --git a/drivers/staging/iio/accel/adis16240.h b/drivers/staging/iio/accel/adis16240.h
index 51a807d..76a4579 100644
--- a/drivers/staging/iio/accel/adis16240.h
+++ b/drivers/staging/iio/accel/adis16240.h
@@ -132,7 +132,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16240_state {
diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index 579b3a2..3e4dd00 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -57,7 +57,7 @@
 /* Reboot memory content */
 #define LIS3L02DQ_REG_CTRL_2_REBOOT_MEMORY	0x10
 
-/* Interupt Enable - applies data ready to the RDY pad */
+/* Interrupt Enable - applies data ready to the RDY pad */
 #define LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT	0x08
 
 /* Enable Data Ready Generation - relationship with previous unclear in docs */
@@ -70,36 +70,36 @@
  * - option for 16 bit left justified */
 #define LIS3L02DQ_REG_CTRL_2_DATA_ALIGNMENT_16_BIT_LEFT_JUSTIFIED	0x01
 
-/* Interupt related stuff */
+/* Interrupt related stuff */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_ADDR			0x23
 
 /* Switch from or combination fo conditions to and */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_BOOLEAN_AND		0x80
 
-/* Latch interupt request,
+/* Latch interrupt request,
  * if on ack must be given by reading the ack register */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC		0x40
 
-/* Z Interupt on High (above threshold)*/
+/* Z Interrupt on High (above threshold)*/
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_HIGH	0x20
-/* Z Interupt on Low */
+/* Z Interrupt on Low */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_LOW	0x10
-/* Y Interupt on High */
+/* Y Interrupt on High */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_HIGH	0x08
-/* Y Interupt on Low */
+/* Y Interrupt on Low */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_LOW	0x04
-/* X Interupt on High */
+/* X Interrupt on High */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_HIGH	0x02
-/* X Interupt on Low */
+/* X Interrupt on Low */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_LOW 0x01
 
-/* Register that gives description of what caused interupt
+/* Register that gives description of what caused interrupt
  * - latched if set in CFG_ADDRES */
 #define LIS3L02DQ_REG_WAKE_UP_SRC_ADDR			0x24
 /* top bit ignored */
-/* Interupt Active */
+/* Interrupt Active */
 #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_ACTIVATED	0x40
-/* Interupts that have been triggered */
+/* Interrupts that have been triggered */
 #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH	0x20
 #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW	0x10
 #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH	0x08
@@ -155,7 +155,7 @@ Form of high byte dependant on justification set in ctrl reg */
  * @inter:		used to check if new interrupt has been triggered
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct lis3l02dq_state {
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index c4b4ab7..3067f96 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -77,7 +77,7 @@ int lis3l02dq_spi_read_reg_8(struct device *dev, u8 reg_address, u8 *val)
 /**
  * lis3l02dq_spi_write_reg_8() - write single byte to a register
  * @dev: device associated with child of actual device (iio_dev or iio_trig)
- * @reg_address: the address of the register to be writen
+ * @reg_address: the address of the register to be written
  * @val: the value to write
  **/
 int lis3l02dq_spi_write_reg_8(struct device *dev,
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 2c461a3..529a3cc 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -217,7 +217,7 @@ static const u8 read_all_tx_array[] = {
 /**
  * lis3l02dq_read_all() Reads all channels currently selected
  * @st:		device specific state
- * @rx_array:	(dma capable) recieve array, must be at least
+ * @rx_array:	(dma capable) receive array, must be at least
  *		4*number of channels
  **/
 static int lis3l02dq_read_all(struct lis3l02dq_state *st, u8 *rx_array)
@@ -409,7 +409,7 @@ static const struct attribute_group lis3l02dq_trigger_attr_group = {
  *
  * As the trigger may occur on any data element being updated it is
  * really rather likely to occur during the read from the previous
- * trigger event.  The only way to discover if this has occured on
+ * trigger event.  The only way to discover if this has occurred on
  * boards not supporting level interrupts is to take a look at the line.
  * If it is indicating another interrupt and we don't seem to have a
  * handler looking at it, then we need to notify the core that we need
diff --git a/drivers/staging/iio/accel/sca3000.h b/drivers/staging/iio/accel/sca3000.h
index 2389284..5971f1d 100644
--- a/drivers/staging/iio/accel/sca3000.h
+++ b/drivers/staging/iio/accel/sca3000.h
@@ -213,7 +213,7 @@ struct sca3000_chip_info {
  * sca3000_read_data() read a series of values from the device
  * @dev:		device
  * @reg_address_high:	start address (decremented read)
- * @rx:			pointer where recieved data is placed. Callee
+ * @rx:			pointer where received data is placed. Callee
  *			responsible for freeing this.
  * @len:		number of bytes to read
  *
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index dde097a..adef546 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -1425,7 +1425,7 @@ error_ret:
 }
 
 /*
- * To keep this managable we always use one of 3 scan modes.
+ * To keep this manageable we always use one of 3 scan modes.
  * Scan 0...3, 0-1,2-3 and 1-0,3-2
  */
 static inline int __max1363_check_event_mask(int thismask, int checkmask)
diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
index 98d1a2c..bfbb22e 100644
--- a/drivers/staging/iio/chrdev.h
+++ b/drivers/staging/iio/chrdev.h
@@ -42,7 +42,7 @@ struct iio_event_data {
 };
 
 /**
- * struct iio_detected_event_list - list element for events that have occured
+ * struct iio_detected_event_list - list element for events that have occurred
  * @list:		linked list header
  * @ev:			the event itself
  * @shared_pointer:	used when the event is shared - i.e. can be escallated
diff --git a/drivers/staging/iio/gyro/adis16060_core.c b/drivers/staging/iio/gyro/adis16060_core.c
index 700eb39..ae53e71 100644
--- a/drivers/staging/iio/gyro/adis16060_core.c
+++ b/drivers/staging/iio/gyro/adis16060_core.c
@@ -30,7 +30,7 @@
  * @us_w:		actual spi_device to write config
  * @us_r:		actual spi_device to read back data
  * @indio_dev:		industrial I/O device structure
- * @buf:		transmit or recieve buffer
+ * @buf:		transmit or receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16060_state {
diff --git a/drivers/staging/iio/gyro/adis16080_core.c b/drivers/staging/iio/gyro/adis16080_core.c
index fb4336c..ef9e304 100644
--- a/drivers/staging/iio/gyro/adis16080_core.c
+++ b/drivers/staging/iio/gyro/adis16080_core.c
@@ -35,7 +35,7 @@
  * struct adis16080_state - device instance specific data
  * @us:			actual spi_device to write data
  * @indio_dev:		industrial I/O device structure
- * @buf:		transmit or recieve buffer
+ * @buf:		transmit or receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16080_state {
diff --git a/drivers/staging/iio/gyro/adis16260.h b/drivers/staging/iio/gyro/adis16260.h
index c1fd4364..1369501 100644
--- a/drivers/staging/iio/gyro/adis16260.h
+++ b/drivers/staging/iio/gyro/adis16260.h
@@ -91,7 +91,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  * @negate:		negate the scale parameter
  **/
diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 248bdd2..7127f26 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -92,7 +92,7 @@ void iio_remove_event_from_list(struct iio_event_handler_list *el,
  *			changes
  * @available_scan_masks: [DRIVER] optional array of allowed bitmasks
  * @trig:		[INTERN] current device trigger (ring buffer modes)
- * @pollfunc:		[DRIVER] function run on trigger being recieved
+ * @pollfunc:		[DRIVER] function run on trigger being received
  **/
 struct iio_dev {
 	int				id;
diff --git a/drivers/staging/iio/imu/adis16300.h b/drivers/staging/iio/imu/adis16300.h
index 1f25d68..c095759 100644
--- a/drivers/staging/iio/imu/adis16300.h
+++ b/drivers/staging/iio/imu/adis16300.h
@@ -99,7 +99,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16300_state {
diff --git a/drivers/staging/iio/imu/adis16350.h b/drivers/staging/iio/imu/adis16350.h
index b00001e..b1ad486 100644
--- a/drivers/staging/iio/imu/adis16350.h
+++ b/drivers/staging/iio/imu/adis16350.h
@@ -105,7 +105,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16350_state {
diff --git a/drivers/staging/iio/imu/adis16400.h b/drivers/staging/iio/imu/adis16400.h
index 6ff33e1..7a12702 100644
--- a/drivers/staging/iio/imu/adis16400.h
+++ b/drivers/staging/iio/imu/adis16400.h
@@ -131,7 +131,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16400_state {
diff --git a/drivers/staging/iio/meter/ade7753.h b/drivers/staging/iio/meter/ade7753.h
index 70dabae..3b9c7f6 100644
--- a/drivers/staging/iio/meter/ade7753.h
+++ b/drivers/staging/iio/meter/ade7753.h
@@ -62,7 +62,7 @@
  * @us:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7753_state {
diff --git a/drivers/staging/iio/meter/ade7754.h b/drivers/staging/iio/meter/ade7754.h
index 8faa9b3..0aa0522 100644
--- a/drivers/staging/iio/meter/ade7754.h
+++ b/drivers/staging/iio/meter/ade7754.h
@@ -80,7 +80,7 @@
  * @us:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7754_state {
diff --git a/drivers/staging/iio/meter/ade7758.h b/drivers/staging/iio/meter/ade7758.h
index df5bb7b..c6fd94f 100644
--- a/drivers/staging/iio/meter/ade7758.h
+++ b/drivers/staging/iio/meter/ade7758.h
@@ -98,7 +98,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7758_state {
diff --git a/drivers/staging/iio/meter/ade7759.h b/drivers/staging/iio/meter/ade7759.h
index e9d1c43..cc76c2c 100644
--- a/drivers/staging/iio/meter/ade7759.h
+++ b/drivers/staging/iio/meter/ade7759.h
@@ -43,7 +43,7 @@
  * @us:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7759_state {
diff --git a/drivers/staging/iio/meter/ade7854.h b/drivers/staging/iio/meter/ade7854.h
index 4ad84a3..79a2110 100644
--- a/drivers/staging/iio/meter/ade7854.h
+++ b/drivers/staging/iio/meter/ade7854.h
@@ -149,7 +149,7 @@
  * @spi:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7854_state {
diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index a367991..7a6ecb7 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -871,7 +871,7 @@ int sst_send_algo_ipc(struct ipc_post **msg)
 }
 
 /**
- * intel_sst_ioctl_dsp - recieves the device ioctl's
+ * intel_sst_ioctl_dsp - receives the device ioctl's
  *
  * @cmd:Ioctl cmd
  * @arg:data
@@ -1067,7 +1067,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("SET_VOLUME recieved for %d!\n",
+		pr_debug("SET_VOLUME received for %d!\n",
 				set_vol.stream_id);
 		if (minor == STREAM_MODULE && set_vol.stream_id == 0) {
 			pr_debug("invalid operation!\n");
@@ -1085,7 +1085,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("IOCTL_GET_VOLUME recieved for stream = %d!\n",
+		pr_debug("IOCTL_GET_VOLUME received for stream = %d!\n",
 				get_vol.stream_id);
 		if (minor == STREAM_MODULE && get_vol.stream_id == 0) {
 			pr_debug("invalid operation!\n");
@@ -1117,7 +1117,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("SNDRV_SST_SET_VOLUME recieved for %d!\n",
+		pr_debug("SNDRV_SST_SET_VOLUME received for %d!\n",
 			set_mute.stream_id);
 		if (minor == STREAM_MODULE && set_mute.stream_id == 0) {
 			retval = -EPERM;
@@ -1153,7 +1153,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_MMAP_CAPTURE): {
 		struct snd_sst_mmap_buffs mmap_buf;
 
-		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE recieved!\n");
+		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -1239,7 +1239,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_SET_TARGET_DEVICE): {
 		struct snd_sst_target_device target_device;
 
-		pr_debug("SET_TARGET_DEVICE recieved!\n");
+		pr_debug("SET_TARGET_DEVICE received!\n");
 		if (copy_from_user(&target_device, (void __user *)arg,
 				sizeof(target_device))) {
 			retval = -EFAULT;
@@ -1256,7 +1256,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_DRIVER_INFO): {
 		struct snd_sst_driver_info info;
 
-		pr_debug("SNDRV_SST_DRIVER_INFO recived\n");
+		pr_debug("SNDRV_SST_DRIVER_INFO received\n");
 		info.version = SST_VERSION_NUM;
 		/* hard coding, shud get sumhow later */
 		info.active_pcm_streams = sst_drv_ctx->stream_cnt -
diff --git a/drivers/staging/intel_sst/intel_sst_dsp.c b/drivers/staging/intel_sst/intel_sst_dsp.c
index 6e5c915..1b56e8b 100644
--- a/drivers/staging/intel_sst/intel_sst_dsp.c
+++ b/drivers/staging/intel_sst/intel_sst_dsp.c
@@ -405,7 +405,7 @@ exit:
 
 }
 
-/* This function is called when FW requests for a particular libary download
+/* This function is called when FW requests for a particular library download
 This function prepares the library to download*/
 int sst_load_library(struct snd_sst_lib_download *lib, u8 ops)
 {
diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
index 8df313d..0f0c5bb 100644
--- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
+++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
@@ -111,7 +111,7 @@
 #define IPC_SST_PERIOD_ELAPSED 0x97 /* period elapsed */
 #define IPC_IA_TARGET_DEV_CHNGD 0x98 /* error in processing a stream */
 
-#define IPC_SST_ERROR_EVENT 0x99 /* Buffer over run occured */
+#define IPC_SST_ERROR_EVENT 0x99 /* Buffer over run occurred */
 /* L2S messages */
 #define IPC_SC_DDR_LINK_UP 0xC0
 #define IPC_SC_DDR_LINK_DOWN 0xC1
diff --git a/drivers/staging/lirc/lirc_ene0100.h b/drivers/staging/lirc/lirc_ene0100.h
index 776b693..ed39aa8 100644
--- a/drivers/staging/lirc/lirc_ene0100.h
+++ b/drivers/staging/lirc/lirc_ene0100.h
@@ -81,7 +81,7 @@
 
 /* CIR block settings */
 #define ENE_CIR_CONF1		0xFEC0
-#define ENE_CIR_CONF1_ADC_ON	0x7	 /* reciever on gpio40 enabled */
+#define ENE_CIR_CONF1_ADC_ON	0x7	 /* receiver on gpio40 enabled */
 #define ENE_CIR_CONF1_LEARN1	(1 << 3) /* enabled on learning mode */
 #define ENE_CIR_CONF1_TX_ON	0x30	 /* enabled on transmit */
 #define ENE_CIR_CONF1_TX_CARR	(1 << 7) /* send TX carrier or not */
diff --git a/drivers/staging/octeon/cvmx-helper.c b/drivers/staging/octeon/cvmx-helper.c
index 5915066..e9c5c83 100644
--- a/drivers/staging/octeon/cvmx-helper.c
+++ b/drivers/staging/octeon/cvmx-helper.c
@@ -691,7 +691,7 @@ int __cvmx_helper_errata_fix_ipd_ptr_alignment(void)
 
 		if (!retry_cnt)
 			cvmx_dprintf("WARNING: FIX_IPD_PTR_ALIGNMENT "
-				     "get_work() timeout occured.\n");
+				     "get_work() timeout occurred.\n");
 
 		/* Free packet */
 		if (work)
diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
index b154be7..b5d21f6 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -80,7 +80,7 @@ static int dcon_init_xo_1(struct dcon_priv *dcon)
 	lob &= ~(1 << DCON_IRQ);
 	outb(lob, 0x4d0);
 
-	/* Register the interupt handler */
+	/* Register the interrupt handler */
 	if (request_irq(DCON_IRQ, &dcon_interrupt, 0, "DCON", dcon)) {
 		printk(KERN_ERR "olpc-dcon: failed to request DCON's irq\n");
 		goto err_req_irq;
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index c45b09e..5557342 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -148,7 +148,7 @@ static struct usb_driver quausb2_usb_driver = {
  * value of the line status flags from the port
  * @shadowMSR: Last received state of the modem status register, holds
  * the value of the modem status received from the port
- * @rcv_flush: Flag indicating that a receive flush has occured on
+ * @rcv_flush: Flag indicating that a receive flush has occurred on
  * the hardware.
  * @xmit_flush: Flag indicating that a transmit flush has been processed by
  * the hardware.
@@ -156,7 +156,7 @@ static struct usb_driver quausb2_usb_driver = {
  * includes the size (excluding header) of URBs that have been submitted but
  * have not yet been sent to to the device, and bytes that have been sent out
  * of the port but not yet reported sent by the "xmit_empty" messages (which
- * indicate the number of bytes sent each time they are recieved, despite the
+ * indicate the number of bytes sent each time they are received, despite the
  * misleading name).
  * - Starts at zero when port is initialised.
  * - is incremented by the size of the data to be written (no headers)
@@ -726,7 +726,7 @@ static int qt2_write(struct tty_struct *tty, struct usb_serial_port *port,
 		return 0;
 	} else if (port_extra->tx_pending_bytes >= QT2_FIFO_DEPTH) {
 		/* buffer is full (==). > should not occur, but would indicate
-		 * that an overflow had occured */
+		 * that an overflow had occurred */
 		dbg("%s(): port transmit buffer is full!", __func__);
 		/* schedule_work(&port->work); commented in vendor driver */
 		return 0;
@@ -823,7 +823,7 @@ static int qt2_write_room(struct tty_struct *tty)
 	 * reduce the free space count by the size of the dispatched write.
 	 * When a "transmit empty" message comes back up the USB read stream,
 	 * we decrement the count by the number of bytes reported sent, thus
-	 * keeping track of the difference between sent and recieved bytes.
+	 * keeping track of the difference between sent and received bytes.
 	 */
 
 	room = (QT2_FIFO_DEPTH - port_extra->tx_pending_bytes);
diff --git a/drivers/staging/rt2860/common/action.c b/drivers/staging/rt2860/common/action.c
index 56ad236..2f21e66 100644
--- a/drivers/staging/rt2860/common/action.c
+++ b/drivers/staging/rt2860/common/action.c
@@ -456,7 +456,7 @@ void PeerHTAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *Elem)
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 62f6f6b..8ce7e16 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -970,7 +970,7 @@ void BASessionTearDownALL(struct rt_rtmp_adapter *pAd, u8 Wcid)
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
@@ -1032,7 +1032,7 @@ void BAOriSessionSetupTimeout(void *SystemSpecific1,
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
diff --git a/drivers/staging/rt2860/common/cmm_data_usb.c b/drivers/staging/rt2860/common/cmm_data_usb.c
index 7c56c2f..b0de809 100644
--- a/drivers/staging/rt2860/common/cmm_data_usb.c
+++ b/drivers/staging/rt2860/common/cmm_data_usb.c
@@ -702,7 +702,7 @@ Arguments:
 	*pRxPending			pending received packet flag
 
 Return Value:
-    the recieved packet
+    the received packet
 
 Note:
 ========================================================================
diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
index 4996258..f4f3caa 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -1852,7 +1852,7 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 	IRQL = DISPATCH_LEVEL
 
 	Note:
-		We need more information to know it's this requst from AP.
+		We need more information to know it's this request from AP.
 		If yes! we need to do extra handling, for example, remove the WPA key.
 		Otherwise on 4-way handshaking will fail, since the WPA key didn't get
 		removed while auto reconnect.
diff --git a/drivers/staging/sbe-2t3e3/io.c b/drivers/staging/sbe-2t3e3/io.c
index b458ff0..467efbd 100644
--- a/drivers/staging/sbe-2t3e3/io.c
+++ b/drivers/staging/sbe-2t3e3/io.c
@@ -68,7 +68,7 @@ void bootrom_write(struct channel *channel, u32 reg, u32 val)
 	/* select BootROM address */
 	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_PROGRAMMING_ADDRESS, reg & 0x3FFFF);
 
-	/* select writting to BootROM */
+	/* select writing to BootROM */
 	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_SERIAL_ROM_AND_MII_MANAGEMENT,
 		 SBE_2T3E3_21143_VAL_WRITE_OPERATION |
 		 SBE_2T3E3_21143_VAL_BOOT_ROM_SELECT |
@@ -312,7 +312,7 @@ void exar7300_write(struct channel *channel, u32 reg, u32 val)
 	cpld_write_nolock(channel, SBE_2T3E3_CPLD_REG_SERIAL_CHIP_SELECT,
 			  cpld_val_map[SBE_2T3E3_CPLD_VAL_LIU_SELECT][channel->h.slot]);
 
-	/* select writting to Serial I/O Bus */
+	/* select writing to Serial I/O Bus */
 	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_SERIAL_ROM_AND_MII_MANAGEMENT,
 		 SBE_2T3E3_21143_VAL_WRITE_OPERATION |
 		 SBE_2T3E3_21143_VAL_SERIAL_ROM_SELECT |
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 71a5fbc..0277911 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -586,7 +586,7 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
 		sep->send_ct, sep->reply_ct);
 
-	/* Check if error occured during poll */
+	/* Check if error occurred during poll */
 	retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 	if (retval2 != 0x0) {
 		dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
diff --git a/drivers/staging/spectra/flash.c b/drivers/staging/spectra/flash.c
index a2f8200..cb8ed46 100644
--- a/drivers/staging/spectra/flash.c
+++ b/drivers/staging/spectra/flash.c
@@ -965,7 +965,7 @@ static void process_cmd_fail_abort(int *first_failed_cmd,
 	if (0 == *first_failed_cmd)
 		*first_failed_cmd = PendingCMD[idx].SBDCmdIndex;
 
-	nand_dbg_print(NAND_DBG_DEBUG, "Uncorrectable error has occured "
+	nand_dbg_print(NAND_DBG_DEBUG, "Uncorrectable error has occurred "
 		"while executing %u Command %u accesing Block %u\n",
 		(unsigned int)p_BTableChangesDelta->ftl_cmd_cnt,
 		PendingCMD[idx].CMD,
diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 51b4a79..4c6592c 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -561,7 +561,7 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
 	}
 	/*
 	 * 2D data sources have only 3 bits for the number of fingers
-	 * supported - so the encoding is a bit wierd.
+	 * supported - so the encoding is a bit weird.
 	 */
 	if ((queries[1] & MASK_3BIT) <= 4)
 		/* add 1 since zero based */
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
index 014f5d5..c214df9 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
@@ -59,7 +59,7 @@ enum hw_mmu_page_size_t {
  * RETURNS:
  *
  *       Type		: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer
  *						Paramater was set to NULL
  *
@@ -102,7 +102,7 @@ static hw_status mmu_flush_entry(const void __iomem *base_address);
  * RETURNS:
  *
  *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
  *						   was set to NULL
  *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
@@ -147,7 +147,7 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
  * RETURNS:
  *
  *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
  *							was set to NULL
  *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
diff --git a/drivers/staging/tidspbridge/include/dspbridge/clk.h b/drivers/staging/tidspbridge/include/dspbridge/clk.h
index b239503..685341c 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/clk.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/clk.h
@@ -55,7 +55,7 @@ extern void dsp_clk_exit(void);
  *      Initializes private state of CLK module.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      CLK initialized.
@@ -71,7 +71,7 @@ void dsp_gpt_wait_overflow(short int clk_id, unsigned int load);
  *  Parameters:
  *  Returns:
  *      0:	Success.
- *	-EPERM:	Error occured while enabling the clock.
+ *	-EPERM:	Error occurred while enabling the clock.
  *  Requires:
  *  Ensures:
  */
@@ -86,7 +86,7 @@ u32 dsp_clock_enable_all(u32 dsp_per_clocks);
  *  Parameters:
  *  Returns:
  *      0:        Success.
- *      -EPERM:      Error occured while disabling the clock.
+ *      -EPERM:      Error occurred while disabling the clock.
  *  Requires:
  *  Ensures:
  */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index 27a21b5..aff2205 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -190,7 +190,7 @@ extern int cmm_get_info(struct cmm_object *hcmm_mgr,
  *      Initializes private state of CMM module.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      CMM initialized.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cod.h b/drivers/staging/tidspbridge/include/dspbridge/cod.h
index 53bd4bb..cb684c1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cod.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cod.h
@@ -249,7 +249,7 @@ extern int cod_get_sym_value(struct cod_manager *cod_mgr_obj,
  *  Parameters:
  *      None.
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      A requirement for each of the other public COD functions.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dev.h b/drivers/staging/tidspbridge/include/dspbridge/dev.h
index f41e478..f92b4be 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dev.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dev.h
@@ -497,7 +497,7 @@ extern void dev_exit(void);
  *      Initialize DEV's private state, keeping a reference count on each call.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      TRUE: A requirement for the other public DEV functions.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index c2ba26c..ed32bf3 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -52,7 +52,7 @@ struct bridge_dev_context;
  *      dev_ctxt:    Handle to Bridge driver defined device context.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL
@@ -91,7 +91,7 @@ typedef int(*fxn_brd_setstate) (struct bridge_dev_context
  *      dsp_addr:       DSP address at which to start execution.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL
@@ -142,7 +142,7 @@ typedef int(*fxn_brd_memcopy) (struct bridge_dev_context
  *      mem_type:       Memory space on DSP to which to transfer.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL;
@@ -205,7 +205,7 @@ typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
  *      dev_ctxt:    Handle to Bridge driver defined device context.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL
@@ -248,7 +248,7 @@ typedef int(*fxn_brd_status) (struct bridge_dev_context *dev_ctxt,
  *      mem_type:       Memory space on DSP from which to transfer.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL;
@@ -274,7 +274,7 @@ typedef int(*fxn_brd_read) (struct bridge_dev_context *dev_ctxt,
  *      mem_type:       Memory space on DSP to which to transfer.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL;
@@ -601,7 +601,7 @@ typedef int(*fxn_chnl_getmgrinfo) (struct chnl_mgr
  *  Returns:
  *      0:            Success;
  *      -EFAULT:        Invalid chnl_obj.
- *      -ETIMEDOUT: Timeout occured before channel could be idled.
+ *      -ETIMEDOUT: Timeout occurred before channel could be idled.
  *  Requires:
  *  Ensures:
  */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/mgr.h b/drivers/staging/tidspbridge/include/dspbridge/mgr.h
index e506c4d..6d5b009 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/mgr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/mgr.h
@@ -195,7 +195,7 @@ extern int mgr_get_dcd_handle(struct mgr_object
  *      call. Initializes the DCD.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      TRUE: A requirement for the other public MGR functions.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index 53da0ef..16371d8 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -44,7 +44,7 @@
  *      -ESPIPE:        iAlg functions not found for a DAIS node.
  *      -EDOM:         attr_in != NULL and attr_in->prio out of
  *                          range.
- *      -EPERM:          A failure occured, unable to allocate node.
+ *      -EPERM:          A failure occurred, unable to allocate node.
  *      -EBADR:    Proccessor is not in the running state.
  *  Requires:
  *      node_init(void) called.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index 5e09fd1..f00dffd 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -89,7 +89,7 @@ extern int proc_auto_start(struct cfg_devnode *dev_node_obj,
  *  Returns:
  *      0     :       SUCCESS
  *      -EFAULT :       Invalid processor handle.
- *      -ETIME:       A Timeout Occured before the Control information
+ *      -ETIME:       A Timeout Occurred before the Control information
  *			  could be sent.
  *      -EPERM   :       General Failure.
  *  Requires:
@@ -169,7 +169,7 @@ extern int proc_enum_nodes(void *hprocessor,
  *      0     :       Success.
  *      -EFAULT :       Invalid processor handle.
  *      -EBADR:    The processor is not in the PROC_RUNNING state.
- *      -ETIME:       A timeout occured before the DSP responded to the
+ *      -ETIME:       A timeout occurred before the DSP responded to the
  *			  querry.
  *      -EPERM   :       Unable to get Resource Information
  *  Requires:
@@ -229,7 +229,7 @@ extern int proc_get_dev_object(void *hprocessor,
  *      call.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      TRUE: A requirement for the other public PROC functions.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/pwr.h b/drivers/staging/tidspbridge/include/dspbridge/pwr.h
index 5e3ab21..0fb0664 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/pwr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/pwr.h
@@ -46,7 +46,7 @@
  *      0:            Success.
  *      0: Success, but the DSP was already asleep.
  *      -EINVAL:    The specified sleep_code is not supported.
- *      -ETIME:       A timeout occured while waiting for DSP sleep
+ *      -ETIME:       A timeout occurred while waiting for DSP sleep
  *                          confirmation.
  *      -EPERM:          General failure, unable to send sleep command to
  *                          the DSP.
@@ -67,7 +67,7 @@ extern int pwr_sleep_dsp(const u32 sleep_code, const u32 timeout);
  *  Returns:
  *      0:            Success.
  *      0:  Success, but the DSP was already awake.
- *      -ETIME:       A timeout occured while waiting for wake
+ *      -ETIME:       A timeout occurred while waiting for wake
  *                          confirmation.
  *      -EPERM:          General failure, unable to send wake command to
  *                          the DSP.
@@ -85,7 +85,7 @@ extern int pwr_wake_dsp(const u32 timeout);
  *  Returns:
  *      0:            Success.
  *      0:  Success, but the DSP was already awake.
- *      -ETIME:       A timeout occured while waiting for wake
+ *      -ETIME:       A timeout occurred while waiting for wake
  *                          confirmation.
  *      -EPERM:          General failure, unable to send wake command to
  *                          the DSP.
@@ -103,7 +103,7 @@ extern int pwr_pm_pre_scale(u16 voltage_domain, u32 level);
  *  Returns:
  *      0:            Success.
  *      0:  Success, but the DSP was already awake.
- *      -ETIME:       A timeout occured while waiting for wake
+ *      -ETIME:       A timeout occurred while waiting for wake
  *                          confirmation.
  *      -EPERM:          General failure, unable to send wake command to
  *                          the DSP.
diff --git a/drivers/staging/vme/bridges/vme_tsi148.h b/drivers/staging/vme/bridges/vme_tsi148.h
index 9f97fa8..a3ac2fe 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.h
+++ b/drivers/staging/vme/bridges/vme_tsi148.h
@@ -212,7 +212,7 @@ static const int TSI148_LCSR_OT[8] = { TSI148_LCSR_OT0, TSI148_LCSR_OT1,
 #define TSI148_LCSR_OFFSET_OTAT		0x1C
 
 /*
- * VMEbus interupt ack
+ * VMEbus interrupt ack
  * offset  200
  */
 #define TSI148_LCSR_VIACK1	0x204
@@ -613,7 +613,7 @@ static const int TSI148_GCSR_MBOX[4] = { TSI148_GCSR_MBOX0,
 /*
  *  PCI-X Status Register (CRG +$054)
  */
-#define TSI148_PCFS_PCIXSTAT_RSCEM     (1<<29)	/* Recieved Split Comp Error */
+#define TSI148_PCFS_PCIXSTAT_RSCEM     (1<<29)	/* Received Split Comp Error */
 #define TSI148_PCFS_PCIXSTAT_DMCRS_M   (7<<26)	/* max Cumulative Read Size */
 #define TSI148_PCFS_PCIXSTAT_DMOST_M   (7<<23)	/* max outstanding Split Trans
 						 */
@@ -982,8 +982,8 @@ static const int TSI148_GCSR_MBOX[4] = { TSI148_GCSR_MBOX0,
 #define TSI148_LCSR_VICR_CNTS_IRQ1     (2<<22)	/* IRQ1 to Cntr */
 #define TSI148_LCSR_VICR_CNTS_IRQ2     (3<<22)	/* IRQ2 to Cntr */
 
-#define TSI148_LCSR_VICR_EDGIS_M       (3<<20)	/* Edge interupt MASK */
-#define TSI148_LCSR_VICR_EDGIS_DIS     (1<<20)	/* Edge interupt Disable */
+#define TSI148_LCSR_VICR_EDGIS_M       (3<<20)	/* Edge interrupt MASK */
+#define TSI148_LCSR_VICR_EDGIS_DIS     (1<<20)	/* Edge interrupt Disable */
 #define TSI148_LCSR_VICR_EDGIS_IRQ1    (2<<20)	/* IRQ1 to Edge */
 #define TSI148_LCSR_VICR_EDGIS_IRQ2    (3<<20)	/* IRQ2 to Edge */
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 638e391..bed9555 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -137,7 +137,7 @@ DEVICE_PARAM(TxDescriptors1,"Number of transmit descriptors1");
 /* IP_byte_align[] is used for IP header unsigned long byte aligned
    0: indicate the IP header won't be unsigned long byte aligned.(Default) .
    1: indicate the IP header will be unsigned long byte aligned.
-      In some enviroment, the IP header should be unsigned long byte aligned,
+      In some environment, the IP header should be unsigned long byte aligned,
       or the packet will be droped when we receive it. (eg: IPVS)
 */
 DEVICE_PARAM(IP_byte_align,"Enable IP header dword aligned");
diff --git a/drivers/staging/vt6655/tether.h b/drivers/staging/vt6655/tether.h
index 787d885d..3b4efb2 100644
--- a/drivers/staging/vt6655/tether.h
+++ b/drivers/staging/vt6655/tether.h
@@ -53,7 +53,7 @@
 #define TYPE_PKT_802_1x     0x888e
 #define TYPE_PKT_PreAuth    0x88C7
 
-#define TYPE_PKT_PING_M_REQ 0x8011      // master reguest
+#define TYPE_PKT_PING_M_REQ 0x8011      // master request
 #define TYPE_PKT_PING_S_GNT 0x8022      // slave grant
 #define TYPE_PKT_PING_M     0x8077      // pingpong master packet
 #define TYPE_PKT_PING_S     0x8088      // pingpong slave packet
@@ -106,7 +106,7 @@
 #define TYPE_PKT_802_1x     0x8e88
 #define TYPE_PKT_PreAuth    0xC788
 
-#define TYPE_PKT_PING_M_REQ 0x1180      // master reguest
+#define TYPE_PKT_PING_M_REQ 0x1180      // master request
 #define TYPE_PKT_PING_S_GNT 0x2280      // slave grant
 #define TYPE_PKT_PING_M     0x7780      // pingpong master packet
 #define TYPE_PKT_PING_S     0x8880      // pingpong slave packet
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 0d11147..a3cad36 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1096,7 +1096,7 @@ else {
         pbyAgc = abyVT3184_AGC;
         wLengthAgc = sizeof(abyVT3184_AGC);
 
-        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, reguest by Jack
+        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, request by Jack
         pDevice->abyBBVGA[1] = 0x10;
         pDevice->abyBBVGA[2] = 0x0;
         pDevice->abyBBVGA[3] = 0x0;
diff --git a/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c b/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
index d43dd85..5573533 100644
--- a/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
+++ b/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
@@ -678,7 +678,7 @@ cy_as_read_intr_status(
 		/*
 		* queue the mailbox data for later processing.
 		* this allows the firmware to move forward and
-		* service the requst from the P port.
+		* service the request from the P port.
 		*/
 		cy_as_ll_queue_mailbox_data(dev_p);
 
diff --git a/drivers/staging/westbridge/astoria/api/src/cyasmisc.c b/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
index 7852410..5748ae6 100644
--- a/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
+++ b/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
@@ -428,7 +428,7 @@ my_misc_callback(cy_as_device *dev_p, uint8_t context,
 				if (v & CY_AS_MEM_P0_VM_SET_CFGMODE)
 					cy_as_hal_print_message(
 					"initialization message "
-					"recieved, but config bit "
+					"received, but config bit "
 					"still set\n");
 
 				v = cy_as_hal_read_register(dev_p->tag,
@@ -436,7 +436,7 @@ my_misc_callback(cy_as_device *dev_p, uint8_t context,
 				if ((v & CY_AS_MEM_RST_RSTCMPT) == 0)
 					cy_as_hal_print_message(
 					"initialization message "
-					"recieved, but reset complete "
+					"received, but reset complete "
 					"bit still not set\n");
 			}
 			break;
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
index 842cd92..b11e476 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
@@ -117,7 +117,7 @@ struct cyasblkdev_blk_data {
 	 * 16 * 4K (64 K per request)*/
 	struct scatterlist	  sg[16];
 
-	/* non-zero enables printk of executed reqests */
+	/* non-zero enables printk of executed requests */
 	unsigned int	dbgprn_flags;
 
 	/*gen_disk for private, system disk */
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
index 0bbb8a3..d1996a2 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
@@ -222,7 +222,7 @@ static int cyasblkdev_queue_thread(void *d)
 			continue;
 		}
 
-		/* new req recieved, issue it to the driver  */
+		/* new req received, issue it to the driver  */
 		set_current_state(TASK_RUNNING);
 
 		#ifndef WESTBRIDGE_NDEBUG
diff --git a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
index 64f078c..d1bbac4 100644
--- a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
+++ b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
@@ -297,7 +297,7 @@ typedef enum cy_as_storage_event {
 	cy_as_storage_inserted,
 
 	/* This event occurs when the West Bridge device
-	 * percieves an interrrupt from an SDIO card */
+	 * perceives an interrupt from an SDIO card */
 	cy_as_sdio_interrupt
 
 } cy_as_storage_event;
@@ -1985,7 +1985,7 @@ cy_as_storage_erase(
    *	type was made
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made to
@@ -2047,7 +2047,7 @@ cy_as_sdio_get_c_i_s_info(
    *	pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
 
 */
 cy_as_return_status_t
@@ -2095,7 +2095,7 @@ cy_as_sdio_query_card(
    *	pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    */
 cy_as_return_status_t
 cy_as_sdio_reset_card(
@@ -2139,7 +2139,7 @@ cy_as_sdio_reset_card(
    * CY_AS_ERROR_NO_SUCH_DEVICE - the specified media/device pair
    *	does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    *	from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in reading
    *	from the media
@@ -2198,7 +2198,7 @@ cy_as_sdio_direct_read(
    * CY_AS_ERROR_NO_SUCH_DEVICE - the specified media/device
    * pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    * from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    * reading from the media
@@ -2262,7 +2262,7 @@ cy_as_sdio_direct_write(
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory
    *	available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2319,7 +2319,7 @@ cy_as_sdio_set_blocksize(
    *	pair does not exist
    * CY_AS_ERROR_ASYNC_PENDING - an async operation is pending
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    *	from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
@@ -2396,7 +2396,7 @@ cy_as_sdio_extended_read(
    * CY_AS_ERROR_ASYNC_PENDING - an async operation is pending
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2471,7 +2471,7 @@ cy_as_sdio_extended_write(
    * pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2714,7 +2714,7 @@ cy_as_sdio_suspend(
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory
    *	available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error
    *	in reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was
diff --git a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h
index 829edde..97fe8b2 100644
--- a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h
+++ b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h
@@ -55,7 +55,7 @@ typedef struct cy_as_usb_inquiry_data_dep {
 typedef struct cy_as_usb_unknown_command_data_dep {
 	/* The media for the event */
 	cy_as_media_type media;
-	/* The length of the requst (should be 16 bytes) */
+	/* The length of the request (should be 16 bytes) */
 	uint16_t reqlen;
 	/* The request */
 	void *request;
diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index d4bdd3e..bd8d3cc 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -1735,7 +1735,7 @@ DESC_STRCT *descp;	// pointer to start of FrameList
 * - in case encapsulation by the HCF is selected:
 *	  -	The FrameList does not consists of at least 2 Descriptors.
 *	  -	The first databuffer does not contain exactly the (space for) the 802.11 header (== 28 words)
-*	  -	The first databuffer does not have a size to additionally accomodate the 802.3 header and the
+*	  -	The first databuffer does not have a size to additionally accommodate the 802.3 header and the
 *		SNAP header of the frame after encapsulation (== 39 words).
 *	  -	The second databuffer does not contain at least DA, SA and 'type/length' (==14 bytes or 7 words)
 *!! The 2nd part of the list of asserts should be kept in sync with put_frame_lst, in order to get
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index 5aa9eb8..5ce3342 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -851,7 +851,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define HCF_ERR_LEN					0x08	/* buffer size insufficient
 		 								  	 *		  -	IFB_ConfigTable too small
 		 								  	 *		  -	hcf_get_info buffer has a size of 0 or 1 or less than needed
-		 							  		 *			to accomodate all data
+		 							  		 *			to accommodate all data
 		 							  		 *		  -	hcf_put_info: CFG_DLNV_DATA exceeds intermediate
 											 *		  buffer size */
 #define HCF_ERR_INCOMP_PRI			0x09	// primary functions are not compatible
diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index 179194e..d540e47 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -80,7 +80,7 @@ static int p80211req_mibset_mibget(wlandevice_t *wlandev,
 /*----------------------------------------------------------------
 * p80211req_dorequest
 *
-* Handles an MLME reqest/confirm message.
+* Handles an MLME request/confirm message.
 *
 * Arguments:
 *	wlandev		WLAN device struct
-- 
1.7.3.4

