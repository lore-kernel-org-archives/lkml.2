Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab1AKLvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:51:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36416 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab1AKLvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:51:17 -0500
X-IronPort-AV: E=Sophos;i="4.60,306,1291611600"; 
   d="scan'208";a="130468376"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
        Stefano.Stabellini@eu.citrix.com, konrad.wilk@oracle.com,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH] xen: rename platform-pci module to xen-platform-pci.
Date: Tue, 11 Jan 2011 11:51:14 +0000
Message-Id: <1294746674-20505-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 11 Jan 2011 11:51:16.0695 (UTC) FILETIME=[DAA11E70:01CBB185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform-pci is rather generic for a modular distro style kernel.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 533a199..f81819b 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -11,9 +11,10 @@ obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XEN_DEV_EVTCHN)	+= xen-evtchn.o
 obj-$(CONFIG_XENFS)		+= xenfs/
 obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
-obj-$(CONFIG_XEN_PLATFORM_PCI)	+= platform-pci.o
+obj-$(CONFIG_XEN_PLATFORM_PCI)	+= xen-platform-pci.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)		+= pci.o
 
 xen-evtchn-y			:= evtchn.o
 
+xen-platform-pci-y		:= platform-pci.o
-- 
1.5.6.5

