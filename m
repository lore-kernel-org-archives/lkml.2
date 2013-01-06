Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3AFQXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 11:23:40 -0500
Received: from [216.228.121.35] ([216.228.121.35]:5800 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3AFQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 11:23:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 06 Jan 2013 08:19:38 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>
CC: <djbw@fb.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/2] dma: tegra: add channel wise pause control support and Tegra114 SoCs.
Date: Sun, 6 Jan 2013 21:52:01 +0530
Message-ID: <1357489323-21359-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add the channel wise pause control on dma driver and then
add support for Tegra114 SoCs.

The orginal change was in single patch and based on review comment, trying to split
the change to have more meaningful changelog matches with actual code change.


Laxman Dewangan (2):
  dma: tegra: add support for channel wise pause
  dma: tegra: add support for Tegra114 SoC

 drivers/dma/tegra20-apb-dma.c |   54 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 49 insertions(+), 5 deletions(-)

