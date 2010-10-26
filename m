Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab0JZUCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:02:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39458 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821Ab0JZT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 10/22] [RFC] trivial: fix typos concerning "function"
Date: Tue, 26 Oct 2010 21:57:07 +0200
Message-Id: <1288123039-22368-10-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

I'm a bit unsure about this patch.  I'm unable to parse both statements.

Cc: netdev@vger.kernel.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/isdn/hisax/isar.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/isar.c b/drivers/isdn/hisax/isar.c
index 40b914b..2e72227 100644
--- a/drivers/isdn/hisax/isar.c
+++ b/drivers/isdn/hisax/isar.c
@@ -1427,8 +1427,8 @@ modeisar(struct BCState *bcs, int mode, int bc)
 					&bcs->hw.isar.reg->Flags))
 					bcs->hw.isar.dpath = 1;
 				else {
-					printk(KERN_WARNING"isar modeisar analog funktions only with DP1\n");
-					debugl1(cs, "isar modeisar analog funktions only with DP1");
+					printk(KERN_WARNING"isar modeisar analog functions only with DP1\n");
+					debugl1(cs, "isar modeisar analog functions only with DP1");
 					return(1);
 				}
 				break;
-- 
1.7.2.3

