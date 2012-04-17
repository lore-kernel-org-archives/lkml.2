Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2DQGK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:10:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7403 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2DQGKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:10:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 16 Apr 2012 23:10:23 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: linux@arm.linux.org.uk, swarren@nvidia.com, olof@lixom.net,
        ccross@android.com, ldewangan@nvidia.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V1 1/2] ARM: dt: tegra_cardhu: als and proximity sensor isl29028 support
Date: Tue, 17 Apr 2012 11:40:01 +0530
Message-Id: <1334643002-6337-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1334643002-6337-1-git-send-email-ldewangan@nvidia.com>
References: <1334643002-6337-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device info for ALS and proximity sensor isl29028.
This device is connected on i2c2 bus.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra-cardhu.dts |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
index ab8d901..30cbd14 100644
--- a/arch/arm/boot/dts/tegra-cardhu.dts
+++ b/arch/arm/boot/dts/tegra-cardhu.dts
@@ -93,6 +93,12 @@
 
 	i2c@7000c500 {
 		clock-frequency = <100000>;
+
+		/* ALS and Proximity sensor */
+		isl29028: isl29028@44 {
+			compatible = "isl,isl29028";
+			reg = <0x44>;
+		};
 	};
 
 	i2c@7000c700 {
-- 
1.7.1.1

