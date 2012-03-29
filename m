Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887Ab2C2VWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:22:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57982 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759474Ab2C2VVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:21:54 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, linux-hams@vger.kernel.org
Subject: [PATCH] hamradio/scc: orphan driver in MAINTAINERS
Date: Thu, 29 Mar 2012 23:21:39 +0200
Message-Id: <1333056099-31530-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The email address doesn't exist anymore and the website yields a 404.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 MAINTAINERS |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f9faade..22da628 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3185,10 +3185,8 @@ F:	include/linux/clockchips.h
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
-M:	Klaus Kudielka <klaus.kudielka@ieee.org>
 L:	linux-hams@vger.kernel.org
-W:	http://www.nt.tuwien.ac.at/~kkudielk/Linux/
-S:	Maintained
+S:	Orphan
 F:	drivers/net/hamradio/dmascc.c
 F:	drivers/net/hamradio/scc.c
 
-- 
1.7.9.1

