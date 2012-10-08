Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2JHQr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:47:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1400 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab2JHQrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:47:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 08 Oct 2012 09:45:09 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>
CC: <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/3] mfd: tps6586x: Convert to irq domain
Date: Mon, 8 Oct 2012 21:43:22 +0530
Message-ID: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series convert the irq implementation to use the
irq domain.
Accordingly, gpio driver and rtc registration is updated.

Laxman Dewangan (3):
  mfd: Convert tps6586x to irq_domain
  mfd: tps6586x: add irq io-resource for rtc sub driver
  mfd: tps6586x: implement gpio_to_irq

 drivers/gpio/gpio-tps6586x.c |    9 ++++
 drivers/mfd/tps6586x.c       |  103 +++++++++++++++++++++++++++++++-----------
 include/linux/mfd/tps6586x.h |    1 +
 3 files changed, 87 insertions(+), 26 deletions(-)

