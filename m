Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0LJNzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:55:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42859 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0LJNzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:55:49 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix typos concerning "consistent"
Date: Fri, 10 Dec 2010 14:55:42 +0100
Message-Id: <1291989342-15763-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
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
 arch/arm/mach-msm/include/mach/entry-macro-qgic.S  |    2 +-
 arch/m68k/mac/psc.c                                |    2 +-
 drivers/net/via-velocity.c                         |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
 drivers/scsi/megaraid/megaraid_mm.c                |    2 +-
 drivers/staging/cxt1e1/hwprobe.c                   |    2 +-
 drivers/staging/cxt1e1/pmcc4.h                     |    2 +-
 drivers/staging/cxt1e1/pmcc4_drv.c                 |    2 +-
 .../staging/tidspbridge/include/dspbridge/drv.h    |    2 +-
 fs/jbd/transaction.c                               |    2 +-
 fs/jbd2/transaction.c                              |    2 +-
 net/ipv6/af_inet6.c                                |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/entry-macro-qgic.S b/arch/arm/mach-msm/include/mach/entry-macro-qgic.S
index 4dc99aa..1246715 100644
--- a/arch/arm/mach-msm/include/mach/entry-macro-qgic.S
+++ b/arch/arm/mach-msm/include/mach/entry-macro-qgic.S
@@ -26,7 +26,7 @@
 	 * The interrupt numbering scheme is defined in the
 	 * interrupt controller spec.  To wit:
 	 *
-	 * Migrated the code from ARM MP port to be more consistant
+	 * Migrated the code from ARM MP port to be more consistent
 	 * with interrupt processing , the following still holds true
 	 * however, all interrupts are treated the same regardless of
 	 * if they are local IPI or PPI
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index ba6ccab..a4c3eb6 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -88,7 +88,7 @@ void __init psc_init(void)
 
 	/*
 	 * The PSC is always at the same spot, but using psc
-	 * keeps things consisant with the psc_xxxx functions.
+	 * keeps things consistent with the psc_xxxx functions.
 	 */
 
 	psc = (void *) PSC_BASE;
diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index cab96ad..09cac70 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -898,7 +898,7 @@ static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
 	set_mii_flow_control(vptr);
 
 	/*
-	   Check if new status is consisent with current status
+	   Check if new status is consistent with current status
 	   if (((mii_status & curr_status) & VELOCITY_AUTONEG_ENABLE) ||
 	       (mii_status==curr_status)) {
 	   vptr->mii_status=mii_check_media_mode(vptr->mac_regs);
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 8cde3a5..a2dbc94 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -186,7 +186,7 @@ enum {
  * struct i2400m_poke_table - Hardware poke table for the Intel 2400m
  *
  * This structure will be used to create a device specific poke table
- * to put the device in a consistant state at boot time.
+ * to put the device in a consistent state at boot time.
  *
  * @address: The device address to poke
  *
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index a7008c0..25506c7 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -224,7 +224,7 @@ mraid_mm_unlocked_ioctl(struct file *filep, unsigned int cmd,
 {
 	int err;
 
-	/* inconsistant: mraid_mm_compat_ioctl doesn't take the BKL */
+	/* inconsistent: mraid_mm_compat_ioctl doesn't take the BKL */
 	mutex_lock(&mraid_mm_mutex);
 	err = mraid_mm_ioctl(filep, cmd, arg);
 	mutex_unlock(&mraid_mm_mutex);
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 89200e7..6db5076 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -317,7 +317,7 @@ c4hw_attach_all (void)
         pr_warning("No boards found\n");
         return ENODEV;
     }
-    /* sanity check for consistant hardware found */
+    /* sanity check for consistent hardware found */
     for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
     {
         if (hi->pci_slot != 0xff && (!hi->addr[0] || !hi->addr[1]))
diff --git a/drivers/staging/cxt1e1/pmcc4.h b/drivers/staging/cxt1e1/pmcc4.h
index ef6ac7f..e046b87 100644
--- a/drivers/staging/cxt1e1/pmcc4.h
+++ b/drivers/staging/cxt1e1/pmcc4.h
@@ -31,7 +31,7 @@
  * $Log: pmcc4.h,v $
  * Revision 1.4  2005/11/01 19:24:48  rickd
  * Remove de-implement function prototypes.  Several <int> to
- * <status_t> changes for consistant usage of same.
+ * <status_t> changes for consistent usage of same.
  *
  * Revision 1.3  2005/09/28 00:10:08  rickd
  * Add GNU license info. Use config params from libsbew.h
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 5c8a3eb..286a4c2 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -44,7 +44,7 @@
  * Code cleanup.  Default channel config to HDLC_FCS16.
  *
  * Revision 2.7  2005/10/18 18:16:30  rickd
- * Further NCOMM code repairs - (1) interrupt matrix usage inconsistant
+ * Further NCOMM code repairs - (1) interrupt matrix usage inconsistent
  * for indexing into nciInterrupt[][], code missing double parameters.
  * (2) check input of ncomm interrupt registration cardID for correct
  * boundary values.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index c1f363e..ca86cf3 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -425,7 +425,7 @@ void bridge_recover_schedule(void);
 /*
  *  ======== mem_ext_phys_pool_init ========
  *  Purpose:
- *      Uses the physical memory chunk passed for internal consitent memory
+ *      Uses the physical memory chunk passed for internal consistent memory
  *      allocations.
  *      physical address based on the page frame address.
  *  Parameters:
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 846a3f3..5b2e4c3 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -207,7 +207,7 @@ repeat_locked:
 	 * the committing transaction.  Really, we only need to give it
 	 * committing_transaction->t_outstanding_credits plus "enough" for
 	 * the log control blocks.
-	 * Also, this test is inconsitent with the matching one in
+	 * Also, this test is inconsistent with the matching one in
 	 * journal_extend().
 	 */
 	if (__log_space_left(journal) < jbd_space_needed(journal)) {
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 6bf0a24..c793490 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -251,7 +251,7 @@ repeat:
 	 * the committing transaction.  Really, we only need to give it
 	 * committing_transaction->t_outstanding_credits plus "enough" for
 	 * the log control blocks.
-	 * Also, this test is inconsitent with the matching one in
+	 * Also, this test is inconsistent with the matching one in
 	 * jbd2_journal_extend().
 	 */
 	if (__jbd2_log_space_left(journal) < jbd_space_needed(journal)) {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 54e8e42..0935c5a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -300,7 +300,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 			goto out;
 		}
 
-		/* Reproduce AF_INET checks to make the bindings consitant */
+		/* Reproduce AF_INET checks to make the bindings consistent */
 		v4addr = addr->sin6_addr.s6_addr32[3];
 		chk_addr_ret = inet_addr_type(net, v4addr);
 		if (!sysctl_ip_nonlocal_bind &&
-- 
1.7.2.3

