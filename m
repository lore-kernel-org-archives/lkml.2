Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2IUI5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:57:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11370 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2IUI4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:56:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 21 Sep 2012 01:54:51 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 5/5] ARM: tegra: enable brcmfmac in defconfig
Date: Fri, 21 Sep 2012 16:55:00 +0800
Message-ID: <1348217700-12309-6-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348217700-12309-1-git-send-email-wni@nvidia.com>
References: <1348217700-12309-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New options enabled:
* CFG80211_WEXT: (dependency)
* BRCMFMAC: wlan driver, enable as module.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index adcf3c2..04b18ea 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -73,6 +73,7 @@ CONFIG_BT_BNEP=y
 CONFIG_BT_HIDP=y
 CONFIG_BT_HCIBTUSB=m
 CONFIG_CFG80211=y
+CONFIG_CFG80211_WEXT=y
 CONFIG_MAC80211=y
 CONFIG_RFKILL=y
 CONFIG_RFKILL_INPUT=y
@@ -98,6 +99,7 @@ CONFIG_USB_PEGASUS=y
 CONFIG_USB_USBNET=y
 CONFIG_USB_NET_SMSC75XX=y
 CONFIG_USB_NET_SMSC95XX=y
+CONFIG_BRCMFMAC=m
 CONFIG_RT2X00=y
 CONFIG_RT2800USB=m
 CONFIG_INPUT_EVDEV=y
-- 
1.7.1

