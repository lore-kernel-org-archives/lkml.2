Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1FPEnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:43:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35393 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1FPEnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:43:09 -0400
Subject: [RFC PATCH 10/11] arm/dt: Add skeleton dtsi file
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 15 Jun 2011 22:43:06 -0600
Message-ID: <20110616044300.29371.38916.stgit@ponder>
In-Reply-To: <20110616042653.29371.2052.stgit@ponder>
References: <20110616042653.29371.2052.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contains the bare minimum template required to boot with the device tree.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/skeleton.dtsi |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/skeleton.dtsi

diff --git a/arch/arm/boot/dts/skeleton.dtsi b/arch/arm/boot/dts/skeleton.dtsi
new file mode 100644
index 0000000..b41d241
--- /dev/null
+++ b/arch/arm/boot/dts/skeleton.dtsi
@@ -0,0 +1,13 @@
+/*
+ * Skeleton device tree; the bare minimum needed to boot; just include and
+ * add a compatible value.  The bootloader will typically populate the memory
+ * node.
+ */
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	chosen { };
+	aliases { };
+	memory { device_type = "memory"; reg = <0 0>; };
+};

