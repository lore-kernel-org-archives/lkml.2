Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab0LMSCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:02:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47535 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0LMSCI (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 13:02:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/9] pci/xen: Make xen_[find|register|unregister]_domain_owner be _GPL
Date: Mon, 13 Dec 2010 13:01:40 -0500
Message-Id: <1292263303-31680-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6d2a986..0fa23c8 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -445,7 +445,7 @@ int xen_find_device_domain_owner(struct pci_dev *dev)
 	spin_unlock(&dev_domain_list_spinlock);
 	return domain;
 }
-EXPORT_SYMBOL(xen_find_device_domain_owner);
+EXPORT_SYMBOL_GPL(xen_find_device_domain_owner);
 
 int xen_register_device_domain_owner(struct pci_dev *dev, uint16_t domain)
 {
@@ -467,7 +467,7 @@ int xen_register_device_domain_owner(struct pci_dev *dev, uint16_t domain)
 	spin_unlock(&dev_domain_list_spinlock);
 	return 0;
 }
-EXPORT_SYMBOL(xen_register_device_domain_owner);
+EXPORT_SYMBOL_GPL(xen_register_device_domain_owner);
 
 int xen_unregister_device_domain_owner(struct pci_dev *dev)
 {
@@ -484,4 +484,4 @@ int xen_unregister_device_domain_owner(struct pci_dev *dev)
 	kfree(owner);
 	return 0;
 }
-EXPORT_SYMBOL(xen_unregister_device_domain_owner);
+EXPORT_SYMBOL_GPL(xen_unregister_device_domain_owner);
-- 
1.7.1

