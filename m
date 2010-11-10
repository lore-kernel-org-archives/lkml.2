Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0KJJUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 04:20:45 -0500
Received: from mail.perches.com ([173.55.12.10]:4912 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab0KJJUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 04:20:42 -0500
Subject: [PATCH] MAINTAINERS: Mark XEN lists subscribers-only
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 01:20:40 -0800
Message-ID: <1289380840.28590.132.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize mailing address address at the same time.
 
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0094224..70604d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6598,14 +6598,14 @@ F:	drivers/platform/x86
 
 XEN PCI SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com
+L:	xen-devel@lists.xensource.com (subscribers-only)
 S:	Supported
 F:	arch/x86/pci/*xen*
 F:	drivers/pci/*xen*
 
 XEN SWIOTLB SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com
+L:	xen-devel@lists.xensource.com (subscribers-only)
 S:	Supported
 F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
@@ -6613,7 +6613,7 @@ F:	drivers/xen/*swiotlb*
 XEN HYPERVISOR INTERFACE
 M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xen.org
+L:	xen-devel@lists.xensource.com (subscribers-only)
 L:	virtualization@lists.osdl.org
 S:	Supported
 F:	arch/x86/xen/


