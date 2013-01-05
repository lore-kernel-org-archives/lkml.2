Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab3AEHqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 02:46:24 -0500
Received: from [216.228.121.35] ([216.228.121.35]:15061 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3AEHqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 02:46:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Jan 2013 23:41:29 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dmitry.torokhov@gmail.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/4] input: keyboard: tegra: cleanups and DT supports
Date: Sat, 5 Jan 2013 13:15:06 +0530
Message-ID: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
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

Changes from V1:
- renames the rows and pins property array.
- nit cleanups.

Laxman Dewangan (4):
  input: keyboard: tegra: fix build warning
  input: keyboard: tegra: use devm_* for resource allocation
  input: keyboard: tegra: add support for rows/cols configuration from
    dt
  input: keyboard: tegra: remove default key mapping

 .../bindings/input/nvidia,tegra20-kbc.txt          |   22 ++
 drivers/input/keyboard/tegra-kbc.c                 |  345 ++++++--------------
 2 files changed, 118 insertions(+), 249 deletions(-)

