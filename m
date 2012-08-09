Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031307Ab2HIPwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:52:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64170 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031272Ab2HIPs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:48:29 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/22] ARM: ux500: Add AB8500 CODEC node to DB8500 Device Tree
Date: Thu,  9 Aug 2012 16:47:38 +0100
Message-Id: <1344527268-5964-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure correct probing and pass though important configuration
options to the AB8500 CODEC driver when DT is enabled

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/db8500.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
index 33fafe3..83ed692 100644
--- a/arch/arm/boot/dts/db8500.dtsi
+++ b/arch/arm/boot/dts/db8500.dtsi
@@ -389,6 +389,12 @@
 					compatible = "stericsson,ab8500-debug";
 				};
 
+				codec: ab8500-codec {
+					compatible = "stericsson,ab8500-codec";
+
+					stericsson,earpeice-cmv = <950>; /* Units in mV. */
+				};
+
 				ab8500-regulators {
 					compatible = "stericsson,ab8500-regulator";
 
-- 
1.7.9.5

