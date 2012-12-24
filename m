Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2LXJwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 04:52:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5532 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab2LXJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 04:52:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Dec 2012 01:51:39 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <a.zummo@towertech.it>
CC: <akpm@linuxfoundation.org>, <broonie@opensource.wolfsonmicro.com>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] rtc: tps65910: cleanups and fixes for wake enable
Date: Mon, 24 Dec 2012 15:21:23 +0530
Message-ID: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleanups the suspend/resume implementation and 
enable system wake through alarm interrupt.

Laxman Dewangan (4):
  rtc: tps65910: enable/disable wake in suspend/resume
  rtc: tps65910: remove un-necessary irq stat save and restore
  rtc: tps65910: use sleep_pm_ops macro for initialising suspend/resume
    callbacks
  rtc: tps65910: set irq flag to IRQF_EARLY_RESUME during irq request

 drivers/rtc/rtc-tps65910.c |   44 ++++++++++++++++----------------------------
 1 files changed, 16 insertions(+), 28 deletions(-)

