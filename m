Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3ADLCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:02:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8063 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3ADLCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:02:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Jan 2013 02:58:24 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dmitry.torokhov@gmail.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] input: keyboard: tegra: cleanups and DT supports
Date: Fri, 4 Jan 2013 16:32:06 +0530
Message-ID: <1357297330-28878-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series:
 - fix build warning,
 - use devm_* for allocation,
 - make column/rows configuration through DT and
 - remove the rarely used  key mapping table.

Laxman Dewangan (4):
  input: keyboard: tegra: fix build warning
  input: keyboard: tegra: use devm_* for resource allocation
  input: keyboard: tegra: add support for rows/cols configuration from
    dt
  input: keyboard: tegra: remove default key mapping

 .../bindings/input/nvidia,tegra20-kbc.txt          |   22 ++
 drivers/input/keyboard/tegra-kbc.c                 |  346 ++++++--------------
 2 files changed, 120 insertions(+), 248 deletions(-)

