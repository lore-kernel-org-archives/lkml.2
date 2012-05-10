Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2EJJxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:53:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2943 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab2EJJwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:52:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 May 2012 02:52:06 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <olof@lixom.net>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] ARM: tegra: config: enable REGULATOR_TPS62360
Date: Thu, 10 May 2012 15:17:55 +0530
Message-ID: <1336643276-16796-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336643276-16796-1-git-send-email-ldewangan@nvidia.com>
References: <1336643276-16796-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable regulator REGULATOR_TPS62360 for the core power
of cardhu.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 7a90abb..415ada1 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -114,6 +114,7 @@ CONFIG_REGULATOR=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
 CONFIG_REGULATOR_GPIO=y
+CONFIG_REGULATOR_TPS62360=y
 CONFIG_REGULATOR_TPS6586X=y
 CONFIG_SOUND=y
 CONFIG_SND=y
-- 
1.7.1.1

