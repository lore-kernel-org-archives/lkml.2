Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2I0SXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:23:41 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47488 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab2I0SWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:22:25 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 14:22:16 EDT
From: Daniel Kiper <daniel.kiper@oracle.com>
To: konrad.wilk@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 08/11] x86/xen: Add kexec/kdump makefile rules
Date: Thu, 27 Sep 2012 20:06:35 +0200
Message-Id: <1348769198-29580-9-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1348769198-29580-8-git-send-email-daniel.kiper@oracle.com>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-8-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.414951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kexec/kdump makefile rules.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 96ab2c0..7a5db44 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -22,3 +22,6 @@ obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
+obj-$(CONFIG_KEXEC)		+= kexec.o
+obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
+obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o
-- 
1.5.6.5

