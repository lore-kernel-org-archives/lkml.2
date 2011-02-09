Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1BIKJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:09:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46670 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1BIKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:07:54 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] trivial: fix typos concerning "resource"
Date: Wed,  9 Feb 2011 11:07:42 +0100
Message-Id: <1297246062-23777-10-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/powerpc/kvm/book3s.c               |    2 +-
 drivers/hwmon/applesmc.c                |    4 ++--
 drivers/isdn/act2000/act2000_isa.c      |    2 +-
 drivers/isdn/gigaset/bas-gigaset.c      |    2 +-
 drivers/isdn/gigaset/common.c           |    4 ++--
 drivers/isdn/hysdn/hycapi.c             |    2 +-
 drivers/isdn/mISDN/l1oip_core.c         |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c |    4 ++--
 drivers/net/spider_net.c                |    2 +-
 drivers/video/efifb.c                   |    2 +-
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index badc983..27d98fd 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -476,7 +476,7 @@ pfn_t kvmppc_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
  * emulate 32 bytes dcbz length.
  *
  * The Book3s_64 inventors also realized this case and implemented a special bit
- * in the HID5 register, which is a hypervisor ressource. Thus we can't use it.
+ * in the HID5 register, which is a hypervisor resource. Thus we can't use it.
  *
  * My approach here is to patch the dcbz instruction on executing pages.
  */
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4c07436..d980338 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1089,7 +1089,7 @@ out:
 	return ret;
 }
 
-/* Create accelerometer ressources */
+/* Create accelerometer resources */
 static int applesmc_create_accelerometer(void)
 {
 	struct input_dev *idev;
@@ -1142,7 +1142,7 @@ out:
 	return ret;
 }
 
-/* Release all ressources used by the accelerometer */
+/* Release all resources used by the accelerometer */
 static void applesmc_release_accelerometer(void)
 {
 	if (!smcreg.has_accelerometer)
diff --git a/drivers/isdn/act2000/act2000_isa.c b/drivers/isdn/act2000/act2000_isa.c
index fea5b78..d6600bc 100644
--- a/drivers/isdn/act2000/act2000_isa.c
+++ b/drivers/isdn/act2000/act2000_isa.c
@@ -175,7 +175,7 @@ act2000_isa_config_port(act2000_card * card, unsigned short portbase)
 }
 
 /*
- * Release ressources, used by an adaptor.
+ * Release resources, used by an adaptor.
  */
 void
 act2000_isa_release(act2000_card * card)
diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index 8a3c5cf..3a79745 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -2423,7 +2423,7 @@ static void gigaset_disconnect(struct usb_interface *interface)
 	/* stop driver (common part) */
 	gigaset_stop(cs);
 
-	/* stop delayed work and URBs, free ressources */
+	/* stop delayed work and URBs, free resources */
 	del_timer_sync(&ucs->timer_ctrl);
 	del_timer_sync(&ucs->timer_atrdy);
 	del_timer_sync(&ucs->timer_cmd_in);
diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index db621db..b8d5b16 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -455,7 +455,7 @@ static void make_invalid(struct cardstate *cs, unsigned mask)
 }
 
 /**
- * gigaset_freecs() - free all associated ressources of a device
+ * gigaset_freecs() - free all associated resources of a device
  * @cs:		device descriptor structure.
  *
  * Stops all tasklets and timers, unregisters the device from all
@@ -1057,7 +1057,7 @@ struct cardstate *gigaset_get_cs_by_tty(struct tty_struct *tty)
 }
 
 /**
- * gigaset_freedriver() - free all associated ressources of a driver
+ * gigaset_freedriver() - free all associated resources of a driver
  * @drv:	driver descriptor structure.
  *
  * Unregisters the driver from the system and deallocates the driver
diff --git a/drivers/isdn/hysdn/hycapi.c b/drivers/isdn/hysdn/hycapi.c
index 6299b06..fca559a 100644
--- a/drivers/isdn/hysdn/hycapi.c
+++ b/drivers/isdn/hysdn/hycapi.c
@@ -691,7 +691,7 @@ int hycapi_init(void)
 hycapi_cleanup(void)
 
 detach the capi-driver to the kernel-capi. Actually this should
-free some more ressources. Do that later.
+free some more resources. Do that later.
 **************************************************************/
 
 void 
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index bd526f6..2f84194 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -46,7 +46,7 @@
 	limitation of B-channels to control bandwidth (1...126)
 	BRI: 1 or 2
 	PRI: 1-30, 31-126 (126, because dchannel ist not counted here)
-	Also limited ressources are used for stack, resulting in less channels.
+	Also limited resources are used for stack, resulting in less channels.
 	It is possible to have more channels than 30 in PRI mode, this must
 	be supported by the application.
 
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 91399c9..be10ba7 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -940,7 +940,7 @@ static
 void free_btres_lock(struct bttv *btv, struct bttv_fh *fh, int bits)
 {
 	if ((fh->resources & bits) != bits) {
-		/* trying to free ressources not allocated by us ... */
+		/* trying to free resources not allocated by us ... */
 		printk("bttv: BUG! (btres)\n");
 	}
 	fh->resources  &= ~bits;
@@ -4460,7 +4460,7 @@ static void __devexit bttv_remove(struct pci_dev *pci_dev)
 	/* free allocated memory */
 	btcx_riscmem_free(btv->c.pci,&btv->main);
 
-	/* free ressources */
+	/* free resources */
 	free_irq(btv->c.pci->irq,btv);
 	iounmap(btv->bt848_mmio);
 	release_mem_region(pci_resource_start(btv->c.pci,0),
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index cb6bcca..c788013 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -2401,7 +2401,7 @@ spider_net_alloc_card(void)
 }
 
 /**
- * spider_net_undo_pci_setup - releases PCI ressources
+ * spider_net_undo_pci_setup - releases PCI resources
  * @card: card structure
  *
  * spider_net_undo_pci_setup releases the mapped regions
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 70477c2..d1dc68e 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -335,7 +335,7 @@ static int __devinit efifb_probe(struct platform_device *dev)
 	size_vmode = efifb_defined.yres * efifb_fix.line_length;
 
 	/*   size_total -- all video memory we have. Used for
-	 *                 entries, ressource allocation and bounds
+	 *                 entries, resource allocation and bounds
 	 *                 checking. */
 	size_total = screen_info.lfb_size;
 	if (size_total < size_vmode)
-- 
1.7.2.3

