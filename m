Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1IWTvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:51:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36449 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1IWTvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:51:50 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] mfd/mc13xxx: fix a sparse warning about mc13xxx_chipname not being declared
Date: Fri, 23 Sep 2011 21:51:42 +0200
Message-Id: <1316807502-27374-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
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
 drivers/mfd/mc13xxx-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index edcd397..e9619ac 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -477,7 +477,7 @@ enum mc13xxx_id {
 	MC13XXX_ID_INVALID,
 };
 
-const char *mc13xxx_chipname[] = {
+static const char *mc13xxx_chipname[] = {
 	[MC13XXX_ID_MC13783] = "mc13783",
 	[MC13XXX_ID_MC13892] = "mc13892",
 };
-- 
1.7.6.3

