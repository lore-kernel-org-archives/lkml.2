Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2FKA7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:30 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40546 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab2FKA6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:31 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 11/14] sta2x11-mfd : add defines for platform devices' names
Date: Mon, 11 Jun 2012 02:57:56 +0200
Message-Id: <1339376279-16753-12-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Since there are now many mfd platform devices, using defines for their
names seems to be a better solution (avoids wasting time in case of
typos, makes it easier to change the name of a device, ....).

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 include/linux/mfd/sta2x11-mfd.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 4d85879..85b2c20 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -37,6 +37,14 @@ enum sta2x11_mfd_plat_dev {
 	sta2x11_n_mfd_plat_devs,
 };
 
+#define STA2X11_MFD_SCTL_NAME	       "sta2x11-sctl"
+#define STA2X11_MFD_GPIO_NAME	       "sta2x11-gpio"
+#define STA2X11_MFD_SCR_NAME	       "sta2x11-scr"
+#define STA2X11_MFD_TIME_NAME	       "sta2x11-time"
+#define STA2X11_MFD_APBREG_NAME	       "sta2x11-apbreg"
+#define STA2X11_MFD_APB_SOC_REGS_NAME  "sta2x11-apb-soc-regs"
+#define STA2X11_MFD_VIC_NAME	       "sta2x11-vic"
+
 extern u32
 __sta2x11_mfd_mask(struct pci_dev *, u32, u32, u32, enum sta2x11_mfd_plat_dev);
 
-- 
1.7.9.1

