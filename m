Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab2LNTGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:06:25 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11999 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2LNTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:06:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 14 Dec 2012 11:06:18 -0800
From: Allen Martin <amartin@nvidia.com>
To: <swarren@wwwdotorg.org>, <ldewangan@nvidia.com>
CC: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Allen Martin <amartin@nvidia.com>
Subject: [PATCH] dt: fix tegra SPI binding examples
Date: Fri, 14 Dec 2012 11:05:12 -0800
Message-ID: <1355511912-23733-1-git-send-email-amartin@nvidia.com>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix name of slink binding and address of sflash example to make it
self consistent.

Change-Id: Ia89c3017c958bdf670036caf516eabce6f893096
Signed-off-by: Allen Martin <amartin@nvidia.com>
---
 Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt |    2 +-
 Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt b/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
index 8cf24f6..7b53da5 100644
--- a/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
+++ b/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
@@ -13,7 +13,7 @@ Recommended properties:
 
 Example:
 
-spi@7000d600 {
+spi@7000c380 {
 	compatible = "nvidia,tegra20-sflash";
 	reg = <0x7000c380 0x80>;
 	interrupts = <0 39 0x04>;
diff --git a/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt b/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
index f5b1ad1..eefe15e 100644
--- a/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
+++ b/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
@@ -13,7 +13,7 @@ Recommended properties:
 
 Example:
 
-slink@7000d600 {
+spi@7000d600 {
 	compatible = "nvidia,tegra20-slink";
 	reg = <0x7000d600 0x200>;
 	interrupts = <0 82 0x04>;
-- 
1.7.10.4

