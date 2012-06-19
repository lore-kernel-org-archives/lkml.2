Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2FSGBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:01:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4031 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2FSGBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:01:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 18 Jun 2012 23:01:30 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <swarren@wwwdotorg.org>
CC: <sameo@linux.intel.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/2] regulator: tps65910: dt: identify regulator by prop regulator-compatible.
Date: Tue, 19 Jun 2012 11:21:25 +0530
Message-ID: <1340085087-6608-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the discussion on patch
 [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911

adding the  property "regulator-compatible" for each regulator of device.
Modifying documentation as well to reflect this change.
Adding common API in regulators/of_regualator to match regulator
by their id. 

Laxman Dewangan (2):
  regulator: support for regulator match by regulator-compatible
  regulator: tps65910: dt: identify regulator by regulator-compatible

 Documentation/devicetree/bindings/mfd/tps65910.txt |   54 +++++++++++++----
 drivers/regulator/of_regulator.c                   |   61 ++++++++++++++++++++
 drivers/regulator/tps65910-regulator.c             |    3 +-
 include/linux/regulator/of_regulator.h             |   13 ++++
 4 files changed, 117 insertions(+), 14 deletions(-)

