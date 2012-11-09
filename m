Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2KINE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:04:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62740 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2KINEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:04:54 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: tegra: tec: Remove redundant DT properties
Date: Fri,  9 Nov 2012 14:04:51 +0100
Message-Id: <1352466291-27333-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352466291-27333-1-git-send-email-thierry.reding@avionic-design.de>
References: <1352466291-27333-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:DIFRt9Zg/BD2WeunbUxpICEpnQa3eaeSzroW+TXHYAp
 f7k5cKAhgOdrEbhVoZ84q4Hl3g8GIdLpN0w51AzN5MgbHLHP6E
 Li1HbLOdAp108dxMxyn7g4u/voqDnaY7BY9Zq/q+qTYFAQzsV0
 ZNxFJlf7Cx3tgfIgyNWIH2LaMJZag8oJ/DmTooW1pkSBz2vCWI
 emxASo5Yf7jUN+mnnsUIxwFFd0MVHAOYyUgNk0szv5aJldYguY
 sjoAowxsZ7Bk4byCclFn9Xwt2lHhqSMtx9GltxTIxHHPi0vREU
 2clyHnpEbHl88I+7ZSFtzYp6znrkWbiBq7bx39VU05W1O5x9Ty
 r3OOeop+xBgA9huL6XuVfXR2/I9nhjbSw19arG/NirPDkhJ1n0
 8j+huuDa75oar+MQUFi1FjSyd5JwFDk3CQ8jZkzoFeqjmTc6G2
 nwpcW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These properties are already set by the tegra20-tamonten.dtsi, so they
don't need to be repeated.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-tec.dts | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index 9aff31b..916bec1 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -7,9 +7,6 @@
 	compatible = "ad,tec", "ad,tamonten", "nvidia,tegra20";
 
 	i2c@7000c000 {
-		clock-frequency = <400000>;
-		status = "okay";
-
 		wm8903: wm8903@1a {
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
-- 
1.8.0

