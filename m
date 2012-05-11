Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903Ab2EKG5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:57:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1652 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab2EKG5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:57:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 May 2012 23:56:00 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ARM: tegra: Make TEGRA{20,30}_MC selectable in defconfig
Date: Fri, 11 May 2012 09:56:26 +0300
Message-ID: <1336719389-28506-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336719389-28506-1-git-send-email-hdoyu@nvidia.com>
References: <20120511095012.57f737d1b0d2536e0d367a9b@nvidia.com>
 <1336719389-28506-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_TEGRA{20,30}_MC depends on CONFIG_MEMORY.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 7a90abb..639778d 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -149,6 +149,7 @@ CONFIG_KEYBOARD_NVEC=y
 CONFIG_SERIO_NVEC_PS2=y
 CONFIG_TEGRA_IOMMU_GART=y
 CONFIG_TEGRA_IOMMU_SMMU=y
+CONFIG_MEMORY=y
 CONFIG_IIO=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
-- 
1.7.5.4

