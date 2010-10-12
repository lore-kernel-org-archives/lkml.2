Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab0JLPv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:51:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31818 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab0JLPvy (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:51:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 22/23] MAINTAINERS: Add myself for Xen PCI and Xen SWIOTLB maintainer.
Date: Tue, 12 Oct 2010 11:44:30 -0400
Message-Id: <1286898271-32018-23-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
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

