Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1LHIQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:16:05 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:65485 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1LHIQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:16:01 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Huang Shijie <b32955@freescale.com>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 0/4] dma: mxs-dma: several bugfixes for the MXS DMA driver
Date: Thu,  8 Dec 2011 09:15:40 +0100
Message-Id: <cover.1323176362.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset fixes some bugs in the MXS DMA driver.

Lothar Waßmann (4):
  fix a typo in comment
  Always leave mxs_dma_init() with the clock disabled.
  Using a static variable for counting the number of CCWs attached to
  Don't use CLKGATE to disable DMA clock.

 drivers/dma/mxs-dma.c |   43 ++++++++-----------------------------------
 1 files changed, 8 insertions(+), 35 deletions(-)

