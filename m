Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab1LEX7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:59:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13091 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab1LEX7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:59:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 05 Dec 2011 15:59:19 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 4/5] Rename propgated to dt binding documentation
Date: Mon,  5 Dec 2011 15:58:06 -0800
Message-Id: <1323129487-24859-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 .../bindings/power_supply/sbs_sbs-battery.txt      |   23 ++++++++++++++++++++
 .../bindings/power_supply/ti_bq20z75.txt           |   23 --------------------
 2 files changed, 23 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/sbs_sbs-battery.txt
 delete mode 100644 Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt

diff --git a/Documentation/devicetree/bindings/power_supply/sbs_sbs-battery.txt b/Documentation/devicetree/bindings/power_supply/sbs_sbs-battery.txt
new file mode 100644
index 0000000..c40e892
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/sbs_sbs-battery.txt
@@ -0,0 +1,23 @@
+SBS sbs-battery
+~~~~~~~~~~
+
+Required properties :
+ - compatible : "sbs,sbs-battery"
+
+Optional properties :
+ - sbs,i2c-retry-count : The number of times to retry i2c transactions on i2c
+   IO failure.
+ - sbs,poll-retry-count : The number of times to try looking for new status
+   after an external change notification.
+ - sbs,battery-detect-gpios : The gpio which signals battery detection and
+   a flag specifying its polarity.
+
+Example:
+
+	bq20z75@b {
+		compatible = "sbs,sbs-battery";
+		reg = < 0xb >;
+		sbs,i2c-retry-count = <2>;
+		sbs,poll-retry-count = <10>;
+		sbs,battery-detect-gpios = <&gpio-controller 122 1>;
+	}
diff --git a/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
deleted file mode 100644
index 7571294..0000000
--- a/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
+++ /dev/null
@@ -1,23 +0,0 @@
-TI bq20z75
-~~~~~~~~~~
-
-Required properties :
- - compatible : "ti,bq20z75"
-
-Optional properties :
- - ti,i2c-retry-count : The number of times to retry i2c transactions on i2c
-   IO failure.
- - ti,poll-retry-count : The number of times to try looking for new status
-   after an external change notification.
- - ti,battery-detect-gpios : The gpio which signals battery detection and
-   a flag specifying its polarity.
-
-Example:
-
-	bq20z75@b {
-		compatible = "ti,bq20z75";
-		reg = < 0xb >;
-		ti,i2c-retry-count = <2>;
-		ti,poll-retry-count = <10>;
-		ti,battery-detect-gpios = <&gpio-controller 122 1>;
-	}
-- 
1.7.0.4

