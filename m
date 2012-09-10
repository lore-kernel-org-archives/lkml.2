Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2IJQEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:04:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54512 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab2IJQEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:04:39 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: pe1dnn@amsat.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]NEXT:staging "wlags49_h2" Fix ypos.
Date: Mon, 10 Sep 2012 09:04:26 -0700
Message-Id: <1347293066-10599-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes typos while reading through staging "wlags49_h2".

 drivers/staging/wlags49_h2/README.ubuntu |   10 +++++-----
 drivers/staging/wlags49_h2/TODO          |   10 +++++-----
 drivers/staging/wlags49_h2/hcf.c         |   20 ++++++++++----------
 drivers/staging/wlags49_h2/mdd.h         |    4 ++--
 drivers/staging/wlags49_h2/sta_h2.c      |    2 +-
 drivers/staging/wlags49_h2/sta_h25.c     |    2 +-
 drivers/staging/wlags49_h2/wl_enc.h      |    2 +-
 drivers/staging/wlags49_h2/wl_internal.h |    2 +-
 drivers/staging/wlags49_h2/wl_main.c     |   14 +++++++-------
 drivers/staging/wlags49_h2/wl_netdev.c   |   10 +++++-----
 drivers/staging/wlags49_h2/wl_pci.c      |    4 ++--
 drivers/staging/wlags49_h2/wl_wext.c     |   22 +++++++++++-----------
 12 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/wlags49_h2/README.ubuntu b/drivers/staging/wlags49_h2/README.ubuntu
index f1483c4..bfad7dc 100644
--- a/drivers/staging/wlags49_h2/README.ubuntu
+++ b/drivers/staging/wlags49_h2/README.ubuntu
@@ -46,12 +46,12 @@ If you have a card using the HERMES II.5 chip you have to make
 changes to the Makefile and uncomment -DHERMES25. This will build
 driver wlags49_h25_cs.
 
-Note: You can detemine the type with command "pccardctrl info"
+Note: You can determine the type with command "pccardctrl info"
         MANIFID: 0156,0002 = HERMES - not supported by this driver
         MANIFID: 0156,0003 = HERMES II   (Wireless B)
         MANIFID: 0156,0004 = HERMES II.5 (Wireless B/G)
 
-After succesfull compile type command
+After successful compile type command
 
 sudo make install
 
@@ -93,7 +93,7 @@ have to "open" the device first to get a handle and after "close" no
 changed; the former ioctl functions are now called before "open" and
 after "close", which was not expected. One of the problems was enable/
 disable of interrupts in the HCF. Interrupt handling starts at "open"
-so if a former "ioctl" routinge is called before "open" or after "close"
+so if a former "ioctl" routine is called before "open" or after "close"
 then nothing should be done with interrupt switching in the HCF. Once
 this was solved most HCF_ASSERTS went away.
 
@@ -120,8 +120,8 @@ include the man page. Even though setting parameters on the module
 does not work anymore but it provides some information about all the
 settings.
 
-I have not have personal contact with Agere, but others have. Agere
-agreed to make their software available under the BSD licence.
+I have no personal contact with Agere, but others have. Agere
+agreed to make their software available under the BSD license.
 This driver is based on the 7.22 version.
 
 The following was mailed by Agere to Andrey Borzenkov about this:
diff --git a/drivers/staging/wlags49_h2/TODO b/drivers/staging/wlags49_h2/TODO
index 94032b6..f1a4561 100644
--- a/drivers/staging/wlags49_h2/TODO
+++ b/drivers/staging/wlags49_h2/TODO
@@ -1,4 +1,4 @@
-First of all, the best thing would be that this driver becomes obsolte by
+First of all, the best thing would be that this driver becomes obsolete by
 adding support for Hermes II and Hermes II.5 cards to the existing orinoco
 driver. The orinoco driver currently only supports Hermes I based cards.
 Since this will not happen by magic and has not happened until now this
@@ -10,11 +10,11 @@ list.
 
 TODO:
 	- verify against a Hermes II.5 card
-	- verify with WPA encription (both with H2 and H2.5 cards)
+	- verify with WPA encryption (both with H2 and H2.5 cards)
 	- sometimes the card does not initialize correctly, retry mechanisms
-	  are build in to catch most cases but not all
+	  are built in to catch most cases but not all
 	- once the driver runs it is very stable, but I have the impression
-	  some the crittical sections take to long
+	  that some of the critical sections take some time.
 	- the driver is split into a Hermes II and a Hermes II.5 part, it
 	  would be nice to handle both with one module instead of two
 	- review by the wireless developer community
@@ -25,7 +25,7 @@ TODO:
 DONE:
 	- verified against a Hermes II card (Thomson Speedtouch 110 PCMCIA
 	  card)
-	- verified with WEP encription
+	- verified with WEP encryption
 
 Please send any patches or complaints about this driver to Greg
 Kroah-Hartman <greg@kroah.com> and Cc: Henk de Groot <pe1dnn@amsat.org>
diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 4235446..4aac26d 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -508,7 +508,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  *    - HCF_ACT_INT_FORCE_ON enable interrupt generation by WaveLAN NIC
  *    - HCF_ACT_INT_OFF      disable interrupt generation by WaveLAN NIC
  *    - HCF_ACT_INT_ON       compensate 1 HCF_ACT_INT_OFF, enable interrupt generation if balance reached
- *    - HCF_ACT_PRS_SCAN     Hermes Probe Respons Scan (F102) command
+ *    - HCF_ACT_PRS_SCAN     Hermes Probe Response Scan (F102) command
  *    - HCF_ACT_RX_ACK       acknowledge non-DMA receiver to Hermes
  *    - HCF_ACT_SCAN         Hermes Inquire Scan (F101) command (non-WARP only)
  *    - HCF_ACT_SLEEP        DDS Sleep request
@@ -571,7 +571,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  * The F/W is wokenup by the HCF when the NIC Interrupts mode are disabled, i.e. at the first HCF_ACT_INT_OFF
  * after going into sleep.
  *
- * The following Miscellanuous actions are defined:
+ * The following Miscellaneous actions are defined:
  *
  * o HCF_ACT_RX_ACK: Receiver Acknowledgement (non-DMA, non-USB mode only)
  * Acking the receiver, frees the NIC memory used to hold the Rx frame and allows the F/W to
@@ -579,7 +579,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  * If the MSF does not need access (any longer) to the current frame, e.g. because it is rejected based on the
  * look ahead or copied to another buffer, the receiver may be acked. Acking earlier is assumed to have the
  * potential of improving the performance.
- * If the MSF does not explitly ack te receiver, the acking is done implicitly if:
+ * If the MSF does not explicitly ack the receiver, the acking is done implicitly if:
  * - the received frame fits in the look ahead buffer, by the hcf_service_nic call that reported the Rx frame
  * - if not in the above step, by hcf_rcv_msg (assuming hcf_rcv_msg is called)
  * - if neither of the above implicit acks nor an explicit ack by the MSF, by the first hcf_service_nic after
@@ -591,9 +591,9 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  * The Inquire Tallies command requests the F/W to provide its current set of tallies.
  * See also hcf_get_info with CFG_TALLIES as parameter.
  *
- * o HCF_ACT_PRS_SCAN: Inquire Probe Respons Scan command
+ * o HCF_ACT_PRS_SCAN: Inquire Probe Response Scan command
  * This command is only operational if the F/W is enabled.
- * The Probe Respons Scan command starts a scan sequence.
+ * The Probe Response Scan command starts a scan sequence.
  * The HCF puts the result of this action in an MSF defined buffer (see CFG_RID_LOG_STRCT).
  *
  * o HCF_ACT_SCAN: Inquire Scan command
@@ -606,7 +606,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  * - NIC interrupts are not disabled while required by parameter action.
  * - an invalid code is specified in parameter action.
  * - HCF_ACT_INT_ON commands outnumber the HCF_ACT_INT_OFF commands.
- * - reentrancy, may be  caused by calling hcf_functions without adequate protection against NIC interrupts or
+ * - reentrancy, may be caused by calling hcf_functions without adequate protection against NIC interrupts or
  *   multi-threading
  *
  * - Since the HCF does not maintain status information relative to the F/W enabled state, it is not asserted
@@ -625,7 +625,7 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  *   change in HREG_EV_STAT matching a bit in HREG_INT_EN, i.e. not if invoked as result of another device
  *   generating an interrupt on the shared interrupt line.
  *   Note 1: it has been observed that under certain adverse conditions on certain platforms the writing of
- *   HREG_INT_EN can apparently fail, therefor it is paramount that HREG_INT_EN is written again with 0 for
+ *   HREG_INT_EN can apparently fail, therefore it is paramount that HREG_INT_EN is written again with 0 for
  *   each and every call to HCF_ACT_INT_OFF.
  *   Note 2: it has been observed that under certain H/W & S/W architectures this logic is called when there is
  *   no NIC at all. To cater for this, the value of HREG_INT_EN is validated. If the unused bit 0x0100 is set,
@@ -902,7 +902,7 @@ hcf_action( IFBP ifbp, hcf_16 action )
  * - A command other than Continue, Enable, Disable, Connect or Disconnect is given.
  * - An invalid combination of the subfields is given or a bit outside the subfields is given.
  * - any return code besides HCF_SUCCESS.
- * - reentrancy, may be  caused by calling a hcf_function without adequate protection against NIC interrupts or
+ * - reentrancy, may be caused by calling a hcf_function without adequate protection against NIC interrupts or
  *   multi-threading
  *
  *.DIAGRAM
@@ -1030,7 +1030,7 @@ hcf_cntl( IFBP ifbp, hcf_16 cmd )
  * hcf_connect passes the MSF-defined location of the IFB to the HCF and grants or revokes access right for the
  * HCF to the IFB. Revoking is done by specifying HCF_DISCONNECT rather than an I/O address for the parameter
  * io_base.  Every call of hcf_connect in "connect" mode, must eventually be followed by a call of hcf_connect
- * in "disconnect" mode. Clalling hcf_connect in "connect"/"disconnect" mode can not be nested.
+ * in "disconnect" mode. Calling hcf_connect in "connect"/"disconnect" mode can not be nested.
  * The IFB address must be used as a handle with all subsequent HCF-function calls and the HCF uses the IFB
  * address as a handle when it performs a call(back) of an MSF-function (i.e. msf_assert).
  *
@@ -1058,7 +1058,7 @@ hcf_cntl( IFBP ifbp, hcf_16 cmd )
  *   specification for S/W reset
  *   Note 2: it turns out that on some H/W constellations, the clock to access the EEProm is not lowered
  *   to an appropriate frequency by HREG_IO_SRESET. By giving an HCMD_INI first, this problem is worked around.
- *2b: Experimentally it is determined over a wide range of F/W versions that waiting for the for Cmd bit in
+ *2b: Experimentally it is determined over a wide range of F/W versions that are waiting for the for Cmd bit in
  *   Ev register gives a workable strategy. The available documentation does not give much clues.
  *4: clear and initialize the IFB
  *   The HCF house keeping info is designed such that zero is the appropriate initial value for as much as
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index 48aa108..0c91497 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -652,7 +652,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define CFG_CNF_WDS_ADDR6				0xFC16		//[AP] Port 6 MAC Adrs of corresponding WDS Link node
 #define CFG_CNF_PM_MCAST_BUF			0xFC17		//[AP] Switch for PM buffereing of Multicast Messages
 #define CFG_CNF_MCAST_PM_BUF			CFG_CNF_PM_MCAST_BUF	//name does not match H-II spec
-#define CFG_CNF_REJECT_ANY				0xFC18		//[AP] Switch for PM buffereing of Multicast Messages
+#define CFG_CNF_REJECT_ANY				0xFC18		//[AP] Switch for PM buffering of Multicast Messages
 
 #define CFG_CNF_ENCRYPTION				0xFC20		//select en/de-cryption of Tx/Rx messages
 #define CFG_CNF_AUTHENTICATION			0xFC21		//[STA] selects Authentication algorithm
@@ -1004,7 +1004,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define CFG_CURRENT_LINK_STATUS			0x090B		//Latest link status got through 0xF200 LinkEvent
 
 /*============================================================ INFORMATION FRAMES =========================*/
-#define CFG_INFO_FRAME_MIN				0xF000		//lowest value representing an Informatio Frame
+#define CFG_INFO_FRAME_MIN				0xF000		//lowest value representing an Information Frame
 
 #define CFG_TALLIES						0xF100		//Communications Tallies
 #define CFG_SCAN						0xF101		//Scan results
diff --git a/drivers/staging/wlags49_h2/sta_h2.c b/drivers/staging/wlags49_h2/sta_h2.c
index f9a3852..00dffe2 100644
--- a/drivers/staging/wlags49_h2/sta_h2.c
+++ b/drivers/staging/wlags49_h2/sta_h2.c
@@ -26,7 +26,7 @@
 
 
 #include "hcfcfg.h"				// to get hcf_16 etc defined as well as
-                                // possible settings which inluence mdd.h or dhf.h
+                                // possible settings which influence mdd.h or dhf.h
 #include "mdd.h"   				//to get COMP_ID_STA etc defined
 #include "dhf.h"   				//used to be "fhfmem.h", to get memblock,plugrecord,
 
diff --git a/drivers/staging/wlags49_h2/sta_h25.c b/drivers/staging/wlags49_h2/sta_h25.c
index 86ca1cd..5b6f670 100644
--- a/drivers/staging/wlags49_h2/sta_h25.c
+++ b/drivers/staging/wlags49_h2/sta_h25.c
@@ -25,7 +25,7 @@
 
 
 #include "hcfcfg.h"				// to get hcf_16 etc defined as well as
-                                // possible settings which inluence mdd.h or dhf.h
+                                // possible settings which influence mdd.h or dhf.h
 #include "mdd.h"   				//to get COMP_ID_STA etc defined
 #include "dhf.h"   				//used to be "fhfmem.h", to get memblock,plugrecord,
 
diff --git a/drivers/staging/wlags49_h2/wl_enc.h b/drivers/staging/wlags49_h2/wl_enc.h
index 46629f3..1804611 100644
--- a/drivers/staging/wlags49_h2/wl_enc.h
+++ b/drivers/staging/wlags49_h2/wl_enc.h
@@ -106,7 +106,7 @@ ENCSTRCT, *PENCSTRCT;
 
 
 /*******************************************************************************
- * function prrottypes
+ * function prototypes
  ******************************************************************************/
 int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen );
 
diff --git a/drivers/staging/wlags49_h2/wl_internal.h b/drivers/staging/wlags49_h2/wl_internal.h
index 480814e..b230781 100644
--- a/drivers/staging/wlags49_h2/wl_internal.h
+++ b/drivers/staging/wlags49_h2/wl_internal.h
@@ -838,7 +838,7 @@ typedef struct dma_strct
 	DESC_STRCT  *rx_packet[NUM_RX_DESC];
 	DESC_STRCT  *rx_reclaim_desc, *tx_reclaim_desc; // Descriptors for host-reclaim purposes (see HCF)
 	int         tx_rsc_ind; // DMA Tx resource indicator is maintained in the MSF, not in the HCF
-	int         rx_rsc_ind; // Also added rx rsource indicator so that cleanup can be performed if alloc fails
+	int         rx_rsc_ind; // Also added rx resource indicator so that cleanup can be performed if alloc fails
 	int         status;
 } DMA_STRCT;
 
diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index bb3733f..f5f120a 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -63,7 +63,7 @@
  *  constant definitions
  ******************************************************************************/
 
-/* Allow support for calling system fcns to access F/W iamge file */
+/* Allow support for calling system fcns to access F/W image file */
 #define __KERNEL_SYSCALLS__
 
 /*******************************************************************************
@@ -1163,7 +1163,7 @@ int 			rc;
 				CNV_INT_TO_LITTLE( lp->hcfCtx.IFB_FWIdentity.version_major ),
 				CNV_INT_TO_LITTLE( lp->hcfCtx.IFB_FWIdentity.version_minor ));
 
-	/* now we wil get the MAC address of the card */
+	/* now we will get the MAC address of the card */
 	lp->ltvRecord.len = 4;
 	if ( CNV_INT_TO_LITTLE( lp->hcfCtx.IFB_FWIdentity.comp_id ) == COMP_ID_FW_AP  ) {
 		lp->ltvRecord.typ = CFG_NIC_MAC_ADDR;
@@ -1374,7 +1374,7 @@ int wl_put_ltv_init( struct wl_private *lp )
 	lp->ltvRecord.len = 2;
 	lp->ltvRecord.typ = CFG_CNTL_OPT;
 
-	/* The Card Services build must ALWAYS configure for 16-bit I/O. PCI or
+	/* The Card Services build must ALWAYS be configured for 16-bit I/O. PCI or
 	   CardBus can be set to either 16/32 bit I/O, or Bus Master DMA, but only
 	   for Hermes-2.5 */
 #ifdef BUS_PCMCIA
@@ -2474,7 +2474,7 @@ void wl_resume(struct net_device *dev)
  *
  *  DESCRIPTION:
  *
- *      This function perfroms a check on the device and calls wl_remove() if
+ *      This function performs a check on the device and calls wl_remove() if
  *  necessary. This function can be used for all bus types, but exists mostly
  *  for the benefit of the Card Services driver, as there are times when
  *  wl_remove() does not get called.
@@ -2596,7 +2596,7 @@ int wl_enable( struct wl_private *lp )
 			lp->portState = WVLAN_PORT_STATE_ENABLED;   //;?bad mnemonic, NIC iso PORT
 #ifdef ENABLE_DMA
 			if ( lp->use_dma ) {
-				wl_pci_dma_hcf_supply( lp );  //;?always succes?
+				wl_pci_dma_hcf_supply( lp );  //;?always successful?
 			}
 #endif
 		}
@@ -2874,7 +2874,7 @@ int wl_mbx( struct wl_private *lp )
  *  DESCRIPTION:
  *
  *      This function will perform the tedious task of endian translating all
- *  fields withtin a mailbox message which need translating.
+ *  fields within a mailbox message which need translating.
  *
  *  PARAMETERS:
  *
@@ -2989,7 +2989,7 @@ void wl_endian_translate_mailbox( ltv_t *ltv )
  *
  *  DESCRIPTION:
  *
- *      This function will process the mailbox data.
+ *      This function processes the mailbox data.
  *
  *  PARAMETERS:
  *
diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index cc56141..fb42140 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -1599,7 +1599,7 @@ void wl_wds_device_dealloc( struct wl_private *lp )
  *  DESCRIPTION:
  *
  *      Used to start the netif queues of all the "virtual" network devices
- *      which repesent the WDS ports.
+ *      which represent the WDS ports.
  *
  *  PARAMETERS:
  *
@@ -1634,7 +1634,7 @@ void wl_wds_netif_start_queue( struct wl_private *lp )
  *  DESCRIPTION:
  *
  *      Used to stop the netif queues of all the "virtual" network devices
- *      which repesent the WDS ports.
+ *      which represent the WDS ports.
  *
  *  PARAMETERS:
  *
@@ -1669,7 +1669,7 @@ void wl_wds_netif_stop_queue( struct wl_private *lp )
  *  DESCRIPTION:
  *
  *      Used to wake the netif queues of all the "virtual" network devices
- *      which repesent the WDS ports.
+ *      which represent the WDS ports.
  *
  *  PARAMETERS:
  *
@@ -1704,7 +1704,7 @@ void wl_wds_netif_wake_queue( struct wl_private *lp )
  *  DESCRIPTION:
  *
  *      Used to signal the network layer that carrier is present on all of the
- *      "virtual" network devices which repesent the WDS ports.
+ *      "virtual" network devices which represent the WDS ports.
  *
  *  PARAMETERS:
  *
@@ -1737,7 +1737,7 @@ void wl_wds_netif_carrier_on( struct wl_private *lp )
  *  DESCRIPTION:
  *
  *      Used to signal the network layer that carrier is NOT present on all of
- *      the "virtual" network devices which repesent the WDS ports.
+ *      the "virtual" network devices which represent the WDS ports.
  *
  *  PARAMETERS:
  *
diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index 457c7ed..a09c3ac 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -223,7 +223,7 @@ int wl_adapter_init_module( void )
  ******************************************************************************/
 void wl_adapter_cleanup_module( void )
 {
-	//;?how comes wl_adapter_cleanup_module is located in a seemingly pci specific module
+	//;?how come wl_adapter_cleanup_module is located in a seemingly pci specific module
     DBG_FUNC( "wl_adapter_cleanup_module" );
     DBG_ENTER( DbgInfo );
 
@@ -899,7 +899,7 @@ int wl_pci_dma_free_tx_packet( struct pci_dev *pdev, struct wl_private *lp,
  *  DESCRIPTION:
  *
  *      Allocates a single Rx packet, consisting of two descriptors and one
- *      contiguous buffer. THe buffer starts with the hermes-specific header.
+ *      contiguous buffer. The buffer starts with the hermes-specific header.
  *      One descriptor points at the start, the other at offset 0x3a of the
  *      buffer.
  *
diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index cef12f7..f553366 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -606,7 +606,7 @@ retry:
 		if (retries < 10) {
 			retries++;
 
-			/* Holding the lock too long, make a gap to allow other processes */
+			/* Holding the lock too long, makes a gap to allow other processes */
 			wl_unlock(lp, &flags);
 			wl_lock( lp, &flags );
 
@@ -618,7 +618,7 @@ retry:
 				goto out_unlock;
 			}
 
-			/* Holding the lock too long, make a gap to allow other processes */
+			/* Holding the lock too long, makes a gap to allow other processes */
 			wl_unlock(lp, &flags);
 			wl_lock( lp, &flags );
 
@@ -631,7 +631,7 @@ retry:
 		}
 	}
 
-	/* Holding the lock too long, make a gap to allow other processes */
+	/* Holding the lock too long, makes a gap to allow other processes */
 	wl_unlock(lp, &flags);
 	wl_lock( lp, &flags );
 
@@ -694,7 +694,7 @@ retry:
 
 	/* Encryption */
 
-	/* Holding the lock too long, make a gap to allow other processes */
+	/* Holding the lock too long, makes a gap to allow other processes */
 	wl_unlock(lp, &flags);
 	wl_lock( lp, &flags );
 
@@ -721,7 +721,7 @@ retry:
 
 	// Retry Limits and Lifetime - NOT SUPPORTED
 
-	/* Holding the lock too long, make a gap to allow other processes */
+	/* Holding the lock too long, makes a gap to allow other processes */
 	wl_unlock(lp, &flags);
 	wl_lock( lp, &flags );
 
@@ -2646,7 +2646,7 @@ retry:
 
 	DBG_TRACE( DbgInfo, "CFG_SCAN_CHANNEL result      : 0x%x\n", status );
 
-	// Holding the lock too long, make a gap to allow other processes
+	// Holding the lock too long, makes a gap to allow other processes
 	wl_unlock(lp, &flags);
 	wl_lock( lp, &flags );
 
@@ -2657,7 +2657,7 @@ retry:
 			DBG_TRACE( DbgInfo, "Reset card to recover, attempt: %d\n", retries );
 			wl_reset( dev );
 
-			// Holding the lock too long, make a gap to allow other processes
+			// Holding the lock too long, makes a gap to allow other processes
 			wl_unlock(lp, &flags);
 			wl_lock( lp, &flags );
 
@@ -2674,7 +2674,7 @@ retry:
 
 	status = hcf_put_info( &( lp->hcfCtx ), (LTVP)&( lp->ltvRecord ));
 
-	// Holding the lock too long, make a gap to allow other processes
+	// Holding the lock too long, makes a gap to allow other processes
 	wl_unlock(lp, &flags);
 	wl_lock( lp, &flags );
 
@@ -2682,7 +2682,7 @@ retry:
 
 	/* Initiate the scan */
 	/* NOTE: Using HCF_ACT_SCAN has been removed, as using HCF_ACT_ACS_SCAN to
-	   retrieve probe responses must always be used to support WPA */
+	   retrieve probe response must always be used to support WPA */
 	status = hcf_action( &( lp->hcfCtx ), HCF_ACT_ACS_SCAN );
 
 	if( status == HCF_SUCCESS ) {
@@ -3055,7 +3055,7 @@ static void flush_tx(struct wl_private *lp)
 	 * Make sure that there is no data queued up in the firmware
 	 * before setting the TKIP keys. If this check is not
 	 * performed, some data may be sent out with incorrect MIC
-	 * and cause synchronizarion errors with the AP
+	 * and cause synchronization errors with the AP
 	 */
 	/* Check every 1ms for 100ms */
 	for (count = 0; count < 100; count++) {
@@ -3655,7 +3655,7 @@ void wl_wext_event_ap( struct net_device *dev )
 	   this event BEFORE sending the association event, as there are timing
 	   issues with the hostap supplicant. The supplicant will attempt to process
 	   an EAPOL-Key frame from an AP before receiving this information, which
-	   is required properly process the said frame. */
+	   is required for a proper processed frame. */
 	wl_wext_event_assoc_ie( dev );
 
 	/* Get the BSSID */
-- 
1.7.9.5

