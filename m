Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2CGFGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:06:35 -0500
Received: from mail-gx0-f202.google.com ([209.85.161.202]:47869 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2CGFGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:06:33 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>
Subject: [RESEND PATCH 2/3] arm: tegra: dts: Add legacy mode support to Tegra2x USB1 port
Date: Tue,  6 Mar 2012 21:04:33 -0800
Message-Id: <1331096674-8324-3-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331096674-8324-1-git-send-email-sjg@chromium.org>
References: <1331096674-8324-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra's USB1 port supports legacy mode, so mark it as such. Even if we
don't use it, we must turn it off in the driver.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 arch/arm/boot/dts/tegra20.dtsi |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index ec1f010..a322c11 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -184,6 +184,7 @@
 		reg = <0xc5000000 0x4000>;
 		interrupts = < 0 20 0x04 >;
 		phy_type = "utmi";
+		nvidia,has-legacy-mode;
 	};
 
 	usb@c5004000 {
-- 
1.7.7.3

