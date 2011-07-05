Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1GEU3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:29:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47736 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1GEU33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:29:29 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 0/3] tegra: Use engineering names in DT compatible properties
Date: Tue,  5 Jul 2011 14:29:19 -0600
Message-Id: <1309897762-23564-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant, these 3 patches are for the devicetree/test branch. I kept them
separated in the hope they'll squash into existing patches already there.

Stephen Warren (3):
  mmc/tegra: Use engineering names in DT compatible property
  ARM: tegra: Use engineering names in DT compatible property
  dt: docs: tegra: Use engineering names in DT compatible property

 Documentation/devicetree/usage-model |   12 ++--
 arch/arm/boot/dts/tegra-harmony.dts  |    4 +-
 arch/arm/boot/dts/tegra-seaboard.dts |    4 +-
 arch/arm/boot/dts/tegra20.dtsi       |  162 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra250.dtsi      |  162 ----------------------------------
 arch/arm/mach-tegra/board-dt.c       |   32 ++++----
 drivers/mmc/host/sdhci-pltfm.c       |    2 +-
 7 files changed, 189 insertions(+), 189 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra20.dtsi
 delete mode 100644 arch/arm/boot/dts/tegra250.dtsi

