Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1AaMAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:00:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53524 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab1AaMAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:00:52 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: dmaengine: i.MX dma fixes
Date: Mon, 31 Jan 2011 13:00:44 +0100
Message-Id: <1296475248-29095-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following contains fixes for the i.MX dma driver.

Sascha

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.pengutronix.de/git/imx/linux-2.6 dmaengine-imxdma

Sascha Hauer (4):
      dmaengine i.MX dma: set maximum segment size for our device
      dmaengine i.MX dma: check sg entries for valid addresses and lengths
      dmaengine i.MX DMA: do not initialize chan_id field
      dmaengine i.MX dma: initialize dma capabilities outside channel loop

 drivers/dma/imx-dma.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)
