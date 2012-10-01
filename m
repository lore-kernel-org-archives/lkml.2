Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2JAPqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:46:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36518 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2JAPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:45:59 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>,
        Jon Loeliger <jdl@jdl.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 0/2] dtc: enable use of pre-processor
Date: Mon,  1 Oct 2012 09:45:49 -0600
Message-Id: <1349106351-17714-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This series adds a build rule to run cpp on *.dtsp prior to invoking dtc.

This patch relies on the patch I recently posted to update the in-kernel
copy of dtc to match the latest upstream version ("[PATCH] dtc: import
latest upstream dtc"; http://www.spinics.net/lists/kernel/msg1410063.html.

Stephen Warren (2):
  kbuild: centralize .dts->.dtb rule
  kbuild: introduce cmd_dtc_cpp

 arch/arm/boot/Makefile           |    4 ----
 arch/arm/boot/dts/skeleton.dtsip |   13 +++++++++++++
 arch/c6x/boot/Makefile           |    3 ---
 arch/openrisc/boot/Makefile      |    3 ---
 arch/powerpc/boot/Makefile       |    4 ----
 scripts/Makefile.lib             |    9 +++++++++
 6 files changed, 22 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm/boot/dts/skeleton.dtsip

