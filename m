Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2LQGSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:18:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12927 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2LQGSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:18:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 16 Dec 2012 22:16:19 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: [PATCH 1/4] ARM: dt: Add doc for ARM Snoop Control Unit(SCU)
Date: Mon, 17 Dec 2012 08:18:01 +0200
Message-ID: <1355725087-11363-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add scu.txt under arm for ARM Snoop Control Unit(SCU)

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 Documentation/devicetree/bindings/arm/scu.txt |   15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/scu.txt

diff --git a/Documentation/devicetree/bindings/arm/scu.txt b/Documentation/devicetree/bindings/arm/scu.txt
new file mode 100644
index 0000000..96264cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/scu.txt
@@ -0,0 +1,15 @@
+* ARM Snoop Control Unit(SCU)
+
+ARM cores often have a configurable SCU to the memory system through
+the AXI interfaces.
+
+Required properties:
+
+- compatible : "arm,cortex-a9-scu"
+- reg : Specifies base physical address and size of the SCU registers.
+
+Example:
+	scu {
+		compatible = "arm,cortex-a9-scu";
+		reg = <0x50040000 0x58>;
+	};
-- 
1.7.9.5

