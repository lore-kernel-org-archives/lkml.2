Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2BWRmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:42:53 -0500
Received: from smtp.citrix.com ([66.165.176.89]:55896 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab2BWRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:42:39 -0500
X-IronPort-AV: E=Sophos;i="4.73,470,1325480400"; 
   d="scan'208";a="22387553"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, david.vrabel@citrix.com,
        Ian.Campbell@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH-WIP 10/13] xen/arm: empty implementation of xen_remap_domain_mfn_range
Date: Thu, 23 Feb 2012 17:48:31 +0000
Message-ID: <1330019314-20865-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index d76f3b4e..986bec3 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -25,6 +25,16 @@ EXPORT_SYMBOL_GPL(xen_have_vector_callback);
 int xen_platform_pci_unplug;
 EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
 
+/* TODO */
+int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
+			       unsigned long addr,
+			       unsigned long mfn, int nr,
+			       pgprot_t prot, unsigned domid)
+{
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
+
 void __ref xen_hvm_init_shared_info(void)
 {
 	int cpu;
-- 
1.7.2.5

