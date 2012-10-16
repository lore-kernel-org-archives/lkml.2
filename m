Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2JPKKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:10:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4332 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2JPKKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:10:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 16 Oct 2012 03:10:12 -0700
From: Sivaram Nair <sivaramn@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <sivaramn@nvidia.com>
Subject: [PATCH 0/2] ARM: tegra: bring back tegra_timer clock
Date: Tue, 16 Oct 2012 13:08:34 +0300
Message-ID: <1350382116-18024-1-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a bug introduced by commit
20f4665831cec65d6e5d33587bba28ffa536b91d by bringing back the
tegra_timer clock.  The above commit caused tegra_init_timer() failing
to get the clk reference.

The first patch renames the existing tegra_timer object to
tegra_sys_timer and the second patch adds previously-removed tegra_timer
clock object.

Sivaram Nair (2):
  ARM: tegra: rename tegra system timer
  ARM: tegra: add tegra_timer clock

 arch/arm/mach-tegra/board-dt-tegra20.c    |    2 +-
 arch/arm/mach-tegra/board-dt-tegra30.c    |    2 +-
 arch/arm/mach-tegra/board.h               |    2 +-
 arch/arm/mach-tegra/tegra20_clocks_data.c |    1 +
 arch/arm/mach-tegra/tegra30_clocks_data.c |    1 +
 arch/arm/mach-tegra/timer.c               |    2 +-
 6 files changed, 6 insertions(+), 4 deletions(-)

