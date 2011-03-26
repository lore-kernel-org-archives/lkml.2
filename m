Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab1CZBTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:19:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44825 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752848Ab1CZBSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:18:34 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/ePIs/MkXebPTNP7GL3kV8ii4G6Z0s6NIbsJFOQ8
	zWq4ps6NRx99z6
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 01/27] staging/ath6kl: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:17:50 +0100
Message-Id: <1301102296-15565-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110314224746.GA21100@kroah.com>
References: <20110314224746.GA21100@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/ath6kl.

WRONG -> RIGHT
accomodate 	-> accommodate
occured 	-> occurred
recieve 	-> receive

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    4 ++--
 drivers/staging/ath6kl/include/common/a_hci.h      |    2 +-
 drivers/staging/ath6kl/include/common/wmi.h        |    2 +-
 drivers/staging/ath6kl/include/htc_api.h           |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index c6488e0..2618e0e 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -285,7 +285,7 @@ static void FailureCallback(void *pContext, int Status)
 {
     struct gmbox_proto_hci_uart  *pProt = (struct gmbox_proto_hci_uart *)pContext; 
     
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
index 1bc2488..0c5000e 100644
--- a/drivers/staging/ath6kl/include/htc_api.h
+++ b/drivers/staging/ath6kl/include/htc_api.h
@@ -209,7 +209,7 @@ struct htc_endpoint_credit_dist {
 typedef enum _HTC_CREDIT_DIST_REASON {
     HTC_CREDIT_DIST_SEND_COMPLETE = 0,     /* credits available as a result of completed
                                               send operations (MANDATORY) resulting in credit reports */
-    HTC_CREDIT_DIST_ACTIVITY_CHANGE = 1,   /* a change in endpoint activity occured (OPTIONAL) */
+    HTC_CREDIT_DIST_ACTIVITY_CHANGE = 1,   /* a change in endpoint activity occurred (OPTIONAL) */
     HTC_CREDIT_DIST_SEEK_CREDITS,          /* an endpoint needs to "seek" credits (OPTIONAL) */
     HTC_DUMP_CREDIT_STATE                  /* for debugging, dump any state information that is kept by
                                               the distribution function */
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 27cb02d..b97e8a4 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -520,7 +520,7 @@ dbglog_parse_debug_logs(s8 *datap, u32 len)
 int
 ar6000_dbglog_get_debug_logs(struct ar6_softc *ar)
 {
-    u32 data[8]; /* Should be able to accomodate struct dbglog_buf_s */
+    u32 data[8]; /* Should be able to accommodate struct dbglog_buf_s */
     u32 address;
     u32 length;
     u32 dropped;
-- 
1.7.3.4

