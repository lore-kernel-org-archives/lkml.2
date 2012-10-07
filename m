Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2JGP4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:56:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8868 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2JGPzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:55:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 07 Oct 2012 08:55:49 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <vbyravarasu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] mfd: tps65090: cleanups and use regmap-irq for interrupt support
Date: Sun, 7 Oct 2012 20:52:15 +0530
Message-ID: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleanups the driver code by removing unused
member, rearranging code and moving irq implementation to regmap-irq
framework.

Laxman Dewangan (5):
  mfd: add battery charger in tps65090 sub devs
  mfd: tps65090: add error prints when mem alloc failed
  mfd: tps65090: remove unused member of struct tps65090
  mfd: tps65090: move register access APIs to header
  mfd: tps65090: use regmap irq framework for interrupt support

 drivers/mfd/tps65090.c       |  312 ++++++++++++++----------------------------
 include/linux/mfd/tps65090.h |   73 ++++++++---
 2 files changed, 159 insertions(+), 226 deletions(-)

