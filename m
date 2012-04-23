Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2DWMNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:13:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12838 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2DWMNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:13:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 23 Apr 2012 05:13:14 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 4/4] ARM: tegra: defconfig: add ISL29028
Date: Mon, 23 Apr 2012 17:41:37 +0530
Message-Id: <1335183097-21104-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com>
References: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISL29028 is ALS and proximity sensor and used in
tegra cardhu.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
 - No change.

 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 66c2dce..99c3e66 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -138,6 +138,7 @@ CONFIG_RTC_DRV_TEGRA=y
 CONFIG_STAGING=y
 CONFIG_IIO=y
 CONFIG_SENSORS_ISL29018=y
+CONFIG_SENSORS_ISL29028=y
 CONFIG_SENSORS_AK8975=y
 CONFIG_MFD_NVEC=y
 CONFIG_KEYBOARD_NVEC=y
-- 
1.7.1.1

