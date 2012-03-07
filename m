Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab2CGFOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:14:17 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40523 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2CGFOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:14:16 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>
Subject: [RESEND PATCH 3/3] arm: tegra: dts: Mark USB1 as an OTG port on Seaboard
Date: Tue,  6 Mar 2012 21:04:34 -0800
Message-Id: <1331096674-8324-4-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331096674-8324-1-git-send-email-sjg@chromium.org>
References: <1331096674-8324-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB1 port on Tegra2 supports operation in host or device modes. On
Seaboard this is possible, so mark the port as OTG.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 arch/arm/boot/dts/tegra-seaboard.dts |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index 876d5c9..dbf1c5a 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -112,6 +112,7 @@
 
 	usb@c5000000 {
 		nvidia,vbus-gpio = <&gpio 24 0>; /* PD0 */
+		dr_mode = "otg";
 	};
 
 	gpio-keys {
-- 
1.7.7.3

