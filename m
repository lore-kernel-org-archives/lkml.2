Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2KTDPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:15:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11767 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2KTDPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:15:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 Nov 2012 19:15:13 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 0/5] mfd: tps65090: cleanups and use regmap-irq for interrupt support
Date: Tue, 20 Nov 2012 08:44:44 +0530
Message-ID: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleanups the driver code by removing unused
member, rearranging code and moving irq implementation to regmap-irq
framework.

Just resending in case of it is missed.

Laxman Dewangan (5):
  mfd: add battery charger in tps65090 sub devs
  mfd: tps65090: add error prints when mem alloc failed
  mfd: tps65090: remove unused member of struct tps65090
  mfd: tps65090: move register access APIs to header
  mfd: tps65090: use regmap irq framework for interrupt support

 drivers/mfd/tps65090.c       |  312 ++++++++++++++----------------------------
 include/linux/mfd/tps65090.h |   73 ++++++++---
 2 files changed, 159 insertions(+), 226 deletions(-)

