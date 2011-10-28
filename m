Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1J1Loc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:44:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33813 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab1J1Loc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:44:32 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 0/3] OMAP: SPI: Driver updates 
Date: Fri, 28 Oct 2011 17:14:16 +0530
Message-ID: <1319802259-16565-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series does the following
1. Optimises the workqueue to have 1 workqueue per controller so
 that one data of one queue doesnt interfere with other.
 Earlier discussion thread 

http://sourceforge.net/mailarchive/forum.php?thread_name=1319210705-18677-1-git-send-email-shubhrajyoti%40ti.com&forum_name=spi-devel-general

2. Call pm_runtime_disable as it got missed out.
3. Error handling in the spi driver is corrected.


Shubhrajyoti D (3):
  OMAP: SPI: Use a workqueue per omap2_mcspi controller
  OMAP: SPI: call pm_runtime_disable in error path and remove
  OMAP: SPI: Correct the error path

 drivers/spi/spi-omap2-mcspi.c |   51 +++++++++++++++++++++++++---------------
 1 files changed, 32 insertions(+), 19 deletions(-)

