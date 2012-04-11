Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574Ab2DKOXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:23:09 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:54952 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760386Ab2DKOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:21:26 -0400
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 11/11] firewire-sbp-target: Add to target Kconfig and Makefile
Date: Wed, 11 Apr 2012 15:20:43 +0100
Message-Id: <1334154043-69076-12-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334154043-69076-1-git-send-email-bootc@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
 <1334154043-69076-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit also adds an entry to the MAINTAINERS file.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 MAINTAINERS             |    9 +++++++++
 drivers/target/Kconfig  |    1 +
 drivers/target/Makefile |    1 +
 3 files changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b31bdff..b084020 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2754,6 +2754,15 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	sound/firewire/
 
+FIREWIRE SBP-2 TARGET
+M:  Chris Boot <bootc@bootc.net>
+L:  linux-scsi@vger.kernel.org
+L:  target-devel@vger.kernel.org
+L:  linux1394-devel@lists.sourceforge.net
+T:  git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
+S:  Maintained
+F:  drivers/target/sbp/
+
 FIREWIRE SUBSYSTEM
 M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index fc5fa9f..2cfa467 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -41,5 +41,6 @@ source "drivers/target/tcm_fc/Kconfig"
 source "drivers/target/iscsi/Kconfig"
 source "drivers/target/tcm_vhost/Kconfig"
 source "drivers/target/usb-gadget/Kconfig"
+source "drivers/target/sbp/Kconfig"
 
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 6b5f526..1ae8862 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_TCM_FC)		+= tcm_fc/
 obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
 obj-$(CONFIG_TCM_VHOST)		+= tcm_vhost/
 obj-$(CONFIG_TARGET_USB_GADGET)	+= usb-gadget/
+obj-$(CONFIG_FIREWIRE_SBP_TARGET) += sbp/
-- 
1.7.9.5

