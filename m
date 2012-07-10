Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2GJL14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:27:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5418 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2GJL1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:27:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 10 Jul 2012 04:27:10 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <w.sang@pengutronix.de>, <khali@linux-fr.org>, <ben-linux@fluff.org>
CC: <swarren@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] i2c: tegra: Code cleanups and suspend/resume related changes
Date: Tue, 10 Jul 2012 16:50:39 +0530
Message-ID: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series does:
- Code cleanups like removing unused variables, using already define function
- Use clock_disable_unprepare in place of clock_disable()
- Use dev_pm_ops for suspend/resume inplace of legacy suspend/resume callbacks.
- Convert suspend/resume to _noirq version to support late suspend/early resume.

Laxman Dewangan (5):
  i2c: tegra: remove unused member variable
  i2c: tegra: use clk_disable_unprepare in place of clk_disable
  i2c: tegra: use of_match_ptr() for match_table initialization
  i2c: tegra: Use struct dev_pm_ops for power management
  i2c: tegra: convert normal suspend/resume to *_noirq

 drivers/i2c/busses/i2c-tegra.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

