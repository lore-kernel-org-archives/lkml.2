Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2HTBIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 21:08:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13740 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2HTBIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 21:08:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 19 Aug 2012 18:08:15 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <thierry.reding@avionic-design.de>, <swarren@wwwdotorg.org>,
        <xxie@nvidia.com>, <lrg@slimlogic.co.uk>, <jhovold@gmail.com>,
        <kyle.manna@fuel7.com>, <rklein@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v2 0/2] mfd: dt: add power off support for Tegra20/Tegra30
Date: Sun, 19 Aug 2012 18:07:54 -0700
Message-ID: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add new property into regulator DT for telling whether or not
to hook pmic's power off routine to system call "pm_power_off".

Patch 1 add power off support for Tegra20 boards using TPS6586x
Patch 2 add power off support for Tegra30 boards using TPS65910

Verified on Seaboard (Tegra20) and Cardhu (Tegra30)

V2:
* Take multiple pmic instances into consideration while assigning global variables
  as per suggestion from Thierry Reding <thierry.reding@avionic-design.de>

V1:
* Based on master branch of sameo/mfd-2.6.git

Bill Huang (2):
  mfd: dt: tps6586x: Add power off control
  mfd: dt: tps65910: add power off control

 Documentation/devicetree/bindings/mfd/tps65910.txt |    4 +++
 .../devicetree/bindings/regulator/tps6586x.txt     |    6 +++++
 drivers/mfd/tps6586x.c                             |   19 +++++++++++++++++
 drivers/mfd/tps65910.c                             |   22 ++++++++++++++++++++
 include/linux/mfd/tps6586x.h                       |    1 +
 include/linux/mfd/tps65910.h                       |    3 ++
 6 files changed, 55 insertions(+), 0 deletions(-)

-- 
1.7.4.1

