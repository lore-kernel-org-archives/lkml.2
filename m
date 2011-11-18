Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1KRRuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:50:08 -0500
Received: from relay04ant.iops.be ([212.53.5.219]:48590 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1KRRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:50:06 -0500
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        James Bottomley <JBottomley@parallels.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] hv: Add Kconfig menu entry
Date: Fri, 18 Nov 2011 18:40:52 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38.8-scst; KDE/4.6.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111181840.52672.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers/*/Kconfig files define a menu entry. Define
a menu item for hv too such that it becomes uniform with e.g.
virtio for at least "make xconfig" and "make menuconfig" users.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 9fa09ac..70f5dde 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -1,3 +1,5 @@
+menu "Microsoft Hyper-V guest support"
+
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
 	depends on X86 && ACPI && PCI
@@ -11,4 +13,4 @@ config HYPERV_UTILS
 	help
 	  Select this option to enable the Hyper-V Utilities.
 
-
+endmenu
-- 
1.7.3.4

