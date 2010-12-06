Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab0LFKKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:10:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58628 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0LFKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:10:02 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH for -rc] dmaengine: i.MX SDMA fixes
Date: Mon,  6 Dec 2010 11:09:56 +0100
Message-Id: <1291630198-9690-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series contains some fixes for the i.MX SDMA driver. Please
consider them for -rc.

Sascha

The following changes since commit 771f8bc71c31c6bd103cdec283012253f352ab1c:

  Merge branch 'slab/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 (2010-12-05 16:45:02 -0800)

are available in the git repository at:

  git://git.pengutronix.de/git/imx/linux-2.6.git sdma-fixes

Sascha Hauer (2):
      dmaengine i.MX SDMA: initialize on module_init
      dmaengine i.MX SDMA: protect channel0

 drivers/dma/imx-sdma.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

