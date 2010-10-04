Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab0JDSQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:16:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31449 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab0JDSN6 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:13:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 22/22] MAINTAINERS: Add myself for Xen PCI and Xen SWIOTLB maintainer.
Date: Mon,  4 Oct 2010 14:13:35 -0400
Message-Id: <1286216015-9710-23-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 668682d..662aa75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6486,6 +6486,20 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.
 S:	Maintained
 F:	drivers/platform/x86
 
+XEN PCI SUBSYSTEM
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	xen-devel@lists.xensource.com
+S:	Supported
+F:	arch/x86/pci/*xen*
+F:	drivers/pci/*xen*
+
+XEN SWIOTLB SUBSYSTEM
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	xen-devel@lists.xensource.com
+S:	Supported
+F:	arch/x86/xen/*swiotlb*
+F:	drivers/xen/*swiotlb*
+
 XEN HYPERVISOR INTERFACE
 M:	Jeremy Fitzhardinge <jeremy@xensource.com>
 M:	Chris Wright <chrisw@sous-sol.org>
-- 
1.7.0.4

