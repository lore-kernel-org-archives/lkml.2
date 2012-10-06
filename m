Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2JFPvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:51:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3257 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab2JFPvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:51:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 06 Oct 2012 08:51:07 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <sameo@linux.intel.com>
CC: <vbyravarasu@nvidia.com>, <axel.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] regulator: tps65090: fix regulator registration and add external control support
Date: Sat, 6 Oct 2012 20:47:45 +0530
Message-ID: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series fixes the regulator registration issue and add support
for external control.
Patch 1: It renames the driver name and regulators to more appropriate.
Patch 2: Fix the issue with regulator registration.
Patch 3: Add LDO support.
Patch 4: Add voltage output level information.
Patch 5: Add support for extenal control for DCDC.

Laxman Dewangan (5):
  regulator: tps65090: rename driver name and regulator name
  regulator; tps65090: Register all regulators in single probe call
  regulator: tps65090: Add support for LDO regulators
  regulator: tps65090: Add voltage out level in platform data
  regulator: tps65090: add external control support for DCDC

 drivers/regulator/tps65090-regulator.c       |  272 ++++++++++++++++++++------
 include/linux/mfd/tps65090.h                 |    1 +
 include/linux/regulator/tps65090-regulator.h |   38 +++--
 3 files changed, 237 insertions(+), 74 deletions(-)

