Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1DDMj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:39:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:2918 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab1DDMj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:39:57 -0400
X-IronPort-AV: E=Sophos;i="4.63,296,1299474000"; 
   d="scan'208";a="143405477"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com
Subject: [PATCH] xen: tidy up whitespace in drivers/xen/Makefile
Date: Mon,  4 Apr 2011 13:39:53 +0100
Message-Id: <1301920793-23901-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
X-OriginalArrivalTime: 04 Apr 2011 12:39:56.0712 (UTC) FILETIME=[67619A80:01CBF2C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various merges over time have led to rather a mish-mash of indentation.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
---
 drivers/xen/Makefile |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index f420f1f..4781f80 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -4,21 +4,21 @@ obj-y	+= xenbus/
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_features.o			:= $(nostackp)
 
-obj-$(CONFIG_BLOCK)		+= biomerge.o
-obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
-obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
-obj-$(CONFIG_XEN_BALLOON)	+= xen-balloon.o
-obj-$(CONFIG_XEN_DEV_EVTCHN)	+= xen-evtchn.o
-obj-$(CONFIG_XEN_GNTDEV)	+= xen-gntdev.o
+obj-$(CONFIG_BLOCK)			+= biomerge.o
+obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
+obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
+obj-$(CONFIG_XEN_BALLOON)		+= xen-balloon.o
+obj-$(CONFIG_XEN_DEV_EVTCHN)		+= xen-evtchn.o
+obj-$(CONFIG_XEN_GNTDEV)		+= xen-gntdev.o
 obj-$(CONFIG_XEN_GRANT_DEV_ALLOC)	+= xen-gntalloc.o
-obj-$(CONFIG_XENFS)		+= xenfs/
+obj-$(CONFIG_XENFS)			+= xenfs/
 obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
-obj-$(CONFIG_XEN_PLATFORM_PCI)	+= xen-platform-pci.o
-obj-$(CONFIG_SWIOTLB_XEN)	+= swiotlb-xen.o
-obj-$(CONFIG_XEN_DOM0)		+= pci.o
+obj-$(CONFIG_XEN_PLATFORM_PCI)		+= xen-platform-pci.o
+obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
+obj-$(CONFIG_XEN_DOM0)			+= pci.o
 
-xen-evtchn-y			:= evtchn.o
+xen-evtchn-y				:= evtchn.o
 xen-gntdev-y				:= gntdev.o
 xen-gntalloc-y				:= gntalloc.o
 
-xen-platform-pci-y		:= platform-pci.o
+xen-platform-pci-y			:= platform-pci.o
-- 
1.7.2.5

