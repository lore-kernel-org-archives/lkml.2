Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab2IXTZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:25:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60588 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab2IXTZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:25:11 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 0/4] deprecate regulator-compatible DT property
Date: Mon, 24 Sep 2012 13:24:59 -0600
Message-Id: <1348514703-10152-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

As explained in patch 1, this series deprecates the regulator-compatible
DT property, and updates various binding documentation and examples for
this change.

I expect patches 1-3 to go into various regulator topic trees, and patch
4 to go into the MFD tree.

Stephen Warren (4):
  regulator: deprecate regulator-compatible DT property
  regulator: tps65217.txt: remove regulator-compatible from DT docs
  regulator: tps6586x: remove regulator-compatible from DT docs
  mfd: max8907: remove regulator-compatible from DT docs

 .../devicetree/bindings/regulator/max8907.txt      |   24 +++-----
 .../devicetree/bindings/regulator/regulator.txt    |    5 +-
 .../devicetree/bindings/regulator/tps65217.txt     |   31 ++-------
 .../devicetree/bindings/regulator/tps6586x.txt     |   66 ++++++--------------
 drivers/regulator/of_regulator.c                   |   25 ++++----
 5 files changed, 50 insertions(+), 101 deletions(-)
