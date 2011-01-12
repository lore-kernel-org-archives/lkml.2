Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1ALKSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:18:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54911 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1ALKSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:18:17 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: dmaengine: Fix i.MX sdma firmware loading
Date: Wed, 12 Jan 2011 11:18:13 +0100
Message-Id: <1294827494-15092-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware loading in the i.MX sdma engine is currently broken. The
following patch fixes this. Dan, please forward this patch for current
-rc.

Sascha Hauer (1):
      dmaengine i.MX SDMA: Fix firmware loading

 drivers/dma/imx-sdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

