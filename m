Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2H0K0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:26:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12978 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab2H0K0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:26:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 27 Aug 2012 03:26:27 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>, <brudley@broadcom.com>, <rvossen@broadcom.com>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list@broadcom.com>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 6/6] ARM: tegra: enable wireless in defconfig
Date: Mon, 27 Aug 2012 18:25:14 +0800
Message-ID: <1346063114-30361-7-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346063114-30361-1-git-send-email-wni@nvidia.com>
References: <1346063114-30361-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New options enabled:
* WIRELESS: (dependency)
* CFG80211_WEXT: (dependency)
* WLAN: (dependency)
* BRCMFMAC: wlan driver, enable as module.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index ef2c679..8fab9e0 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -73,7 +73,11 @@ CONFIG_BT_RFCOMM=y
 CONFIG_BT_BNEP=y
 CONFIG_BT_HIDP=y
 CONFIG_BT_HCIBTUSB=m
+CONFIG_WLAN=y
+CONFIG_BRCMFMAC=m
+CONFIG_WIRELESS=y
 CONFIG_CFG80211=y
+CONFIG_CFG80211_WEXT=y
 CONFIG_MAC80211=y
 CONFIG_RFKILL=y
 CONFIG_RFKILL_INPUT=y
-- 
1.7.1

