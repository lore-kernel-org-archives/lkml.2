Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763279Ab2KBRp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:45:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15752 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab2KBRp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:45:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 02 Nov 2012 10:33:02 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <linus.walleij@linaro.org>,
        <grant.likely@secretlab.ca>
CC: <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH REPOST 0/3] mfd: tps6586x: Convert to irq domain
Date: Fri, 2 Nov 2012 23:13:31 +0530
Message-ID: <1351878214-11543-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series convert the irq implementation to use the
irq domain.
Accordingly, gpio driver and rtc registration is updated.

Reposting the series and adding the reviwed by Mark and acked by Linus W
for the respective patches.

Laxman Dewangan (3):
  mfd: Convert tps6586x to irq_domain
  mfd: tps6586x: add irq io-resource for rtc sub driver
  mfd: tps6586x: implement gpio_to_irq

 drivers/gpio/gpio-tps6586x.c |    9 ++++
 drivers/mfd/tps6586x.c       |  103 +++++++++++++++++++++++++++++++-----------
 include/linux/mfd/tps6586x.h |    1 +
 3 files changed, 87 insertions(+), 26 deletions(-)

