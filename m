Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1C3RBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:01:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49582 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab1C3RBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GarINmMS3s2HHJLZ824g1dphcyQjYMXpP9Q+mPvgPJswQAwcMDmHDEUhe4qegsgpS7
         tFXn6K7kOSJ2JTdtcYiV56aTqtdAACf6ns8wuDsU55irj5d4ZfjZ9PY5X6q+DD8WZ/e1
         UrUSvX4pYStjzSW0B2/jbwoAcZiGGIDy6PAvA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/5]remove one to many ttt's.
Date: Wed, 30 Mar 2011 10:01:17 -0700
Message-Id: <1301504478-3450-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>
References: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes one to many ttt's in some comments.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/ia64/hp/common/sba_iommu.c    |    2 +-
 drivers/firmware/efivars.c         |    2 +-
 drivers/macintosh/therm_pm72.c     |    4 ++--
 drivers/media/dvb/dvb-usb/dw2102.c |    2 +-
 drivers/message/i2o/README.ioctl   |    2 +-
 drivers/net/s2io.c                 |    2 +-
 drivers/net/ucc_geth_ethtool.c     |    2 +-
 drivers/net/usb/usbnet.c           |    2 +-
 drivers/scsi/lpfc/lpfc_hw.h        |    2 +-
 drivers/tty/n_gsm.c                |    2 +-
 drivers/usb/host/imx21-dbg.c       |    2 +-
 drivers/usb/misc/usbtest.c         |    2 +-
 fs/nfsd/stats.c                    |    2 +-
 fs/xfs/xfs_inode.c                 |    2 +-
 include/linux/posix-clock.h        |    2 +-
 15 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 4ce8d13..ab3ccab 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1063,7 +1063,7 @@ static void sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
 		/*
 		** Address does not fall w/in IOVA, must be bypassing
 		*/
-		DBG_BYPASS("sba_unmap_single_atttrs() bypass addr: 0x%lx\n",
+		DBG_BYPASS("sba_unmap_single_attrs() bypass addr: 0x%lx\n",
 			   iova);
 
 #ifdef ENABLE_MARK_CLEAN
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ff0c373..5629a0c 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -321,7 +321,7 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
 
 /*
  * Generic read/write functions that call the specific functions of
- * the atttributes...
+ * the attributes...
  */
 static ssize_t efivar_attr_show(struct kobject *kobj, struct attribute *attr,
 				char *buf)
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index bca2af2..7cd50bf 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -44,11 +44,11 @@
  * TODO:  - Check MPU structure version/signature
  *        - Add things like /sbin/overtemp for non-critical
  *          overtemp conditions so userland can take some policy
- *          decisions, like slewing down CPUs
+ *          decisions, like slowing down CPUs
  *	  - Deal with fan and i2c failures in a better way
  *	  - Maybe do a generic PID based on params used for
  *	    U3 and Drives ? Definitely need to factor code a bit
- *          bettter... also make sensor detection more robust using
+ *          better... also make sensor detection more robust using
  *          the device-tree to probe for them
  *        - Figure out how to get the slots consumption and set the
  *          slots fan accordingly
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index f5b9da1..d312323 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -1377,7 +1377,7 @@ static struct rc_map_table rc_map_su3000_table[] = {
 	{ 0x0f, KEY_BLUE },	/* bottom yellow button */
 	{ 0x14, KEY_AUDIO },	/* Snapshot */
 	{ 0x38, KEY_TV },	/* TV/Radio */
-	{ 0x0c, KEY_ESC }	/* upper Red buttton */
+	{ 0x0c, KEY_ESC }	/* upper Red button */
 };
 
 static struct rc_map_dvb_usb_table_table keys_tables[] = {
diff --git a/drivers/message/i2o/README.ioctl b/drivers/message/i2o/README.ioctl
index 65c0c47..5fb195af4 100644
--- a/drivers/message/i2o/README.ioctl
+++ b/drivers/message/i2o/README.ioctl
@@ -110,7 +110,7 @@ V. Getting Logical Configuration Table
       ENOBUFS     Buffer not large enough.  If this occurs, the required
                   buffer length is written into *(lct->reslen)
 
-VI. Settting Parameters
+VI. Setting Parameters
    
    SYNOPSIS 
  
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 356e74d..8874914 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -7231,7 +7231,7 @@ static void do_s2io_card_down(struct s2io_nic *sp, int do_io)
 		/* As per the HW requirement we need to replenish the
 		 * receive buffer to avoid the ring bump. Since there is
 		 * no intention of processing the Rx frame at this pointwe are
-		 * just settting the ownership bit of rxd in Each Rx
+		 * just setting the ownership bit of rxd in Each Rx
 		 * ring to HW and set the appropriate buffer size
 		 * based on the ring mode
 		 */
diff --git a/drivers/net/ucc_geth_ethtool.c b/drivers/net/ucc_geth_ethtool.c
index 6f92e48..cfd8881 100644
--- a/drivers/net/ucc_geth_ethtool.c
+++ b/drivers/net/ucc_geth_ethtool.c
@@ -6,7 +6,7 @@
  * Author: Li Yang <leoli@freescale.com>
  *
  * Limitation:
- * Can only get/set setttings of the first queue.
+ * Can only get/set settings of the first queue.
  * Need to re-open the interface manually after changing some parameters.
  *
  * This program is free software; you can redistribute  it and/or modify it
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 95c41d5..1919a6d 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -109,7 +109,7 @@ int usbnet_get_endpoints(struct usbnet *dev, struct usb_interface *intf)
 
 		/* take the first altsetting with in-bulk + out-bulk;
 		 * remember any status endpoint, just in case;
-		 * ignore other endpoints and altsetttings.
+		 * ignore other endpoints and altsettings.
 		 */
 		for (ep = 0; ep < alt->desc.bNumEndpoints; ep++) {
 			struct usb_host_endpoint	*e;
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 95f11ed..86b6f7e 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1002,7 +1002,7 @@ typedef struct _ELS_PKT {	/* Structure is in Big Endian format */
 #define  SLI_MGMT_GRPL     0x102	/* Get registered Port list */
 #define  SLI_MGMT_GPAT     0x110	/* Get Port attributes */
 #define  SLI_MGMT_RHBA     0x200	/* Register HBA */
-#define  SLI_MGMT_RHAT     0x201	/* Register HBA atttributes */
+#define  SLI_MGMT_RHAT     0x201	/* Register HBA attributes */
 #define  SLI_MGMT_RPRT     0x210	/* Register Port */
 #define  SLI_MGMT_RPA      0x211	/* Register Port attributes */
 #define  SLI_MGMT_DHBA     0x300	/* De-register HBA */
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 176f632..be75b95 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2124,7 +2124,7 @@ static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 
 /**
  *	gsmld_detach_gsm	-	stop doing 0710 mux
- *	@tty: tty atttached to the mux
+ *	@tty: tty attached to the mux
  *	@gsm: mux
  *
  *	Shutdown and then clean up the resources used by the line discipline
diff --git a/drivers/usb/host/imx21-dbg.c b/drivers/usb/host/imx21-dbg.c
index 512f647..6d75334 100644
--- a/drivers/usb/host/imx21-dbg.c
+++ b/drivers/usb/host/imx21-dbg.c
@@ -384,7 +384,7 @@ static void debug_isoc_show_one(struct seq_file *s,
 	seq_printf(s, "%s %d:\n"
 		"cc=0X%02X\n"
 		"scheduled frame %d (%d)\n"
-		"submittted frame %d (%d)\n"
+		"submitted frame %d (%d)\n"
 		"completed frame %d (%d)\n"
 		"requested length=%d\n"
 		"completed length=%d\n\n",
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 388cc12..ff9a01f 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -104,7 +104,7 @@ get_endpoints(struct usbtest_dev *dev, struct usb_interface *intf)
 		alt = intf->altsetting + tmp;
 
 		/* take the first altsetting with in-bulk + out-bulk;
-		 * ignore other endpoints and altsetttings.
+		 * ignore other endpoints and altsettings.
 		 */
 		for (ep = 0; ep < alt->desc.bNumEndpoints; ep++) {
 			struct usb_host_endpoint	*e;
diff --git a/fs/nfsd/stats.c b/fs/nfsd/stats.c
index 5232d3e..a2e2402 100644
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -8,7 +8,7 @@
  *			Statistsics for the reply cache
  *	fh <stale> <total-lookups> <anonlookups> <dir-not-in-dcache> <nondir-not-in-dcache>
  *			statistics for filehandle lookup
- *	io <bytes-read> <bytes-writtten>
+ *	io <bytes-read> <bytes-written>
  *			statistics for IO throughput
  *	th <threads> <fullcnt> <10%-20%> <20%-30%> ... <90%-100%> <100%> 
  *			time (seconds) when nfsd thread usage above thresholds
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 742c833..8f335b1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1470,7 +1470,7 @@ xfs_itruncate_finish(
 	 * file but the log buffers containing the free and reallocation
 	 * don't, then we'd end up with garbage in the blocks being freed.
 	 * As long as we make the new_size permanent before actually
-	 * freeing any blocks it doesn't matter if they get writtten to.
+	 * freeing any blocks it doesn't matter if they get written to.
 	 *
 	 * The callers must signal into us whether or not the size
 	 * setting here must be synchronous.  There are a few cases
diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index 369e19d..29ff1fa 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -44,7 +44,7 @@ struct posix_clock;
  * @timer_create:   Create a new timer
  * @timer_delete:   Remove a previously created timer
  * @timer_gettime:  Get remaining time and interval of a timer
- * @timer_setttime: Set a timer's initial expiration and interval
+ * @timer_settime: Set a timer's initial expiration and interval
  * @fasync:         Optional character device fasync method
  * @mmap:           Optional character device mmap method
  * @open:           Optional character device open method
-- 
1.7.4.1

