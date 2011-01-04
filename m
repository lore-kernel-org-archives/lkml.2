Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1ADX2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:28:04 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:49733
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750954Ab1ADX2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:28:02 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
Subject: [PATCH 2/3] Staging: rt2860: Fix space after unary '*' operator.
Date: Wed,  5 Jan 2011 00:27:44 +0100
Message-Id: <1294183665-5995-3-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294183665-5995-1-git-send-email-agimenez@sysvalve.es>
References: <1294183665-5995-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch error.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/rt2860/rt_linux.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 92ff543..3efb88f 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -102,8 +102,8 @@ extern const struct iw_handler_def rt28xx_iw_handler_def;
 /***********************************************************************************
  *	OS Specific definitions and data structures
  ***********************************************************************************/
-typedef int (*HARD_START_XMIT_FUNC) (struct sk_buff * skb,
-				     struct net_device * net_dev);
+typedef int (*HARD_START_XMIT_FUNC) (struct sk_buff *skb,
+				     struct net_device *net_dev);
 
 #ifdef RTMP_MAC_PCI
 #ifndef PCI_DEVICE
@@ -366,7 +366,7 @@ typedef void (*TIMER_FUNCTION) (unsigned long);
 
 #define ONE_TICK 1
 
-static inline void NdisGetSystemUpTime(unsigned long * time)
+static inline void NdisGetSystemUpTime(unsigned long *time)
 {
 	*time = jiffies;
 }
@@ -815,7 +815,7 @@ void linux_pci_unmap_single(struct rt_rtmp_adapter *pAd, dma_addr_t dma_addr,
 /***********************************************************************************
  *	Other function prototypes definitions
  ***********************************************************************************/
-void RTMP_GetCurrentSystemTime(LARGE_INTEGER * time);
+void RTMP_GetCurrentSystemTime(LARGE_INTEGER *time);
 int rt28xx_packet_xmit(struct sk_buff *skb);
 
 #ifdef RTMP_MAC_PCI
@@ -827,8 +827,8 @@ IRQ_HANDLE_TYPE rt2860_interrupt(int irq, void *dev_instance);
 
 int rt28xx_sta_ioctl(struct net_device *net_dev, IN OUT struct ifreq *rq, int cmd);
 
-extern int ra_mtd_write(int num, loff_t to, size_t len, const u_char * buf);
-extern int ra_mtd_read(int num, loff_t from, size_t len, u_char * buf);
+extern int ra_mtd_write(int num, loff_t to, size_t len, const u_char *buf);
+extern int ra_mtd_read(int num, loff_t from, size_t len, u_char *buf);
 
 #define GET_PAD_FROM_NET_DEV(_pAd, _net_dev)	(_pAd) = (struct rt_rtmp_adapter *)(_net_dev)->ml_priv;
 
-- 
1.7.2.3

