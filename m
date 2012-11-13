Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2KMNvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:51:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18492 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2KMNvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:51:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 13 Nov 2012 05:51:45 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <broonie@opensource.wolfsonmicro.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 0/3] mfd: tps6586x: Convert to irq domain
Date: Tue, 13 Nov 2012 19:18:04 +0530
Message-ID: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
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

