Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2FKA7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:46 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40531 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab2FKA63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:29 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 05/14] sta2x11-mfd : make enum sta2x11_mfd_plat_dev public
Date: Mon, 11 Jun 2012 02:57:50 +0200
Message-Id: <1339376279-16753-6-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

This is needed to implement the sta2x11_xxxx_mask() functions as static
inlines invoking a common __sta2x11_mfd_mask.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c       |    7 -------
 include/linux/mfd/sta2x11-mfd.h |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 744bdd0..1aa9c78 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -35,13 +35,6 @@
 
 #include <asm/sta2x11.h>
 
-enum sta2x11_mfd_plat_dev {
-	sta2x11_sctl = 0,
-	sta2x11_apbreg = 1,
-	sta2x11_apb_soc_regs = 2,
-	sta2x11_n_mfd_plat_devs,
-};
-
 /* This describes STA2X11 MFD chip for us, we may have several */
 struct sta2x11_mfd {
 	struct sta2x11_instance *instance;
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index d179227..2867d55 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -26,6 +26,13 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
+enum sta2x11_mfd_plat_dev {
+	sta2x11_sctl = 0,
+	sta2x11_apbreg = 1,
+	sta2x11_apb_soc_regs = 2,
+	sta2x11_n_mfd_plat_devs,
+};
+
 /*
  * The MFD PCI block includes the GPIO peripherals and other register blocks.
  * For GPIO, we have 32*4 bits (I use "gsta" for "gpio sta2x11".)
-- 
1.7.9.1

