Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab1J1LmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:42:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60499 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1J1LmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:42:13 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 0/3] OMAP: SPI: Driver updates 
Date: Fri, 28 Oct 2011 17:11:52 +0530
Message-ID: <1319802115-16499-1-git-send-email-shubhrajyoti@ti.com>
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

