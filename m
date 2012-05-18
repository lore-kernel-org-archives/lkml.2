Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778Ab2ERUhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:37:01 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2294 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2ERUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:36:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 May 2012 13:35:44 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@slimlogic.co.uk>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/3] mfd: tps65910: dt: cleanups in device node parsing
Date: Sat, 19 May 2012 02:01:40 +0530
Message-ID: <1337373103-23933-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch series organizing the processing of device node locally specific
to driver.
- The gpio specific processing is moved to gpio driver.
- Core will only process the non-subdevices information.
- Also keep the allocated pointer for device node in to global structure
  so that sub devices can use this.

This patch series is generated on-top of Samuel's mfd subsystem tree.


Laxman Dewangan (3):
  mfd: save device node parsed platform data for sub devices
  mfd: remove the parsing of dt info for gpio
  gpio: tps65910: dt: process gpio specific device node info

 drivers/gpio/gpio-tps65910.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/tps65910.c       |   21 +++++----------------
 include/linux/mfd/tps65910.h |    3 +++
 3 files changed, 44 insertions(+), 16 deletions(-)

