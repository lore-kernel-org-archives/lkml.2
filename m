Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1BIKIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:08:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46673 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab1BIKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:08:02 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] trivial: fix typos concerning "first"
Date: Wed,  9 Feb 2011 11:07:37 +0100
Message-Id: <1297246062-23777-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/media/video/omap1_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index 0a2fb2b..1495d20 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -835,7 +835,7 @@ static irqreturn_t cam_isr(int irq, void *data)
 				/*
 				 * If exactly 2 sgbufs from the next sglist have
 				 * been programmed into the DMA engine (the
-				 * frist one already transfered into the DMA
+				 * first one already transfered into the DMA
 				 * runtime register set, the second one still
 				 * in the programming set), then we are in sync.
 				 */
-- 
1.7.2.3

