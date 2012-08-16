Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab2HPPiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:38:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4836 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642Ab2HPPgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:36:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336363200"; 
   d="scan'208";a="205386129"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <tim@xen.org>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH v3 06/25] docs: Xen ARM DT bindings
Date: Thu, 16 Aug 2012 16:35:58 +0100
Message-ID: <1345131377-14713-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a doc to describe the Xen ARM device tree bindings

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: devicetree-discuss@lists.ozlabs.org
CC: David Vrabel <david.vrabel@citrix.com>
---
 Documentation/devicetree/bindings/arm/xen.txt |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/xen.txt

diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
new file mode 100644
index 0000000..ec6d884
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/xen.txt
@@ -0,0 +1,22 @@
+* Xen hypervisor device tree bindings
+
+Xen ARM virtual platforms shall have the following properties:
+
+- compatible:
+	compatible = "xen,xen", "xen,xen-<version>";
+  where <version> is the version of the Xen ABI of the platform.
+
+- reg: specifies the base physical address and size of a region in
+  memory where the grant table should be mapped to, using an
+  HYPERVISOR_memory_op hypercall. 
+
+- interrupts: the interrupt used by Xen to inject event notifications.
+
+
+Example:
+
+hypervisor {
+	compatible = "xen,xen", "xen,xen-4.3";
+	reg = <0xb0000000 0x20000>;
+	interrupts = <1 15 0xf08>;
+};
-- 
1.7.2.5

