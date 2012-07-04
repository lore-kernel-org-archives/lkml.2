Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab2GDJhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:37:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3989 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab2GDJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:37:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jul 2012 02:36:43 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@nvidia.com>, <olof@lixom.net>, <ccross@android.com>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <arnd@arndb.de>, <grant.likely@secretlab.ca>,
        <cjb@laptop.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 5/5] ARM: tegra: enable wireless in defconfig
Date: Wed, 4 Jul 2012 17:34:48 +0800
Message-ID: <1341394488-13169-6-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341394488-13169-1-git-send-email-wni@nvidia.com>
References: <1341394488-13169-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New options enabled:
* WIRELESS: (dependency)
* CFG80211: (dependency)
* WLAN: (dependency)
* BRCMFMAC: wlan driver, enable as module.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 4be9c1e..c0aa6d9 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -67,7 +67,8 @@ CONFIG_INET6_IPCOMP=y
 CONFIG_IPV6_MIP6=y
 CONFIG_IPV6_TUNNEL=y
 CONFIG_IPV6_MULTIPLE_TABLES=y
-# CONFIG_WIRELESS is not set
+CONFIG_WIRELESS=y
+CONFIG_CFG80211=y
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
@@ -87,7 +88,8 @@ CONFIG_USB_PEGASUS=y
 CONFIG_USB_USBNET=y
 CONFIG_USB_NET_SMSC75XX=y
 CONFIG_USB_NET_SMSC95XX=y
-# CONFIG_WLAN is not set
+CONFIG_WLAN=y
+CONFIG_BRCMFMAC=m
 CONFIG_INPUT_EVDEV=y
 CONFIG_INPUT_MISC=y
 CONFIG_INPUT_MPU3050=y
-- 
1.7.1

