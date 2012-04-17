Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2DQGKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:10:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1663 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2DQGKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:10:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 16 Apr 2012 23:10:18 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: linux@arm.linux.org.uk, swarren@nvidia.com, olof@lixom.net,
        ccross@android.com, ldewangan@nvidia.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V1 0/2] ARM: dt: add ALS and proximity sensor ISL29028
Date: Tue, 17 Apr 2012 11:40:00 +0530
Message-Id: <1334643002-6337-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the entry of ISL29028 in dts file of tegra_cardhu and the tegra
defconfig file for building it.

Laxman Dewangan (2):
  ARM: dt: tegra_cardhu: als and proximity sensor isl29028 support
  ARM: config: tegra: add ISL29028

 arch/arm/boot/dts/tegra-cardhu.dts |    6 ++++++
 arch/arm/configs/tegra_defconfig   |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

