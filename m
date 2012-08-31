Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2HaLdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:33:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8826 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2HaLdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:33:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 31 Aug 2012 04:26:17 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 3/4] tegra: dt: add label to tegra20's PWM
Date: Fri, 31 Aug 2012 20:34:05 +0900
Message-ID: <1346412846-17102-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346412846-17102-1-git-send-email-acourbot@nvidia.com>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary to reference the PWM in board device trees.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 405d167..67a6cd9 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -123,7 +123,7 @@
 		status = "disabled";
 	};
 
-	pwm {
+	pwm: pwm {
 		compatible = "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
 		#pwm-cells = <2>;
-- 
1.7.12

