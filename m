Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab1GEEYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 00:24:42 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:43457 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1GEEYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 00:24:41 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] backlight: ams369fg06: fix section mismatch warning
Date: Tue,  5 Jul 2011 13:16:34 +0900
Message-Id: <1309839394-23189-1-git-send-email-jg1.han@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix section mismatch warning by adding the correct annotation __devinit
to the driver's probe function.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 86a7daf..97f6f41 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -473,7 +473,7 @@ static const struct backlight_ops ams369fg06_backlight_ops = {
 	.update_status = ams369fg06_set_brightness,
 };
 
-static int __init ams369fg06_probe(struct spi_device *spi)
+static int __devinit ams369fg06_probe(struct spi_device *spi)
 {
 	int ret = 0;
 	struct ams369fg06 *lcd = NULL;
-- 
1.7.1

