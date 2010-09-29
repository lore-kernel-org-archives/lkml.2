Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0I2Izp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:55:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36210 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab0I2Izo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:55:44 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] MAINTAINERS: add i2c branch for embedded platforms
Date: Wed, 29 Sep 2010 10:55:15 +0200
Message-Id: <1285750515-12252-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1267441936-4432-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1267441936-4432-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

When I suggested the patch that resulted in

	0e53300 (MAINTAINERS: add i2c tree for embedded platforms)

Russell correctly objected that this needs a branch name as there are
different branches intended for upstream.  Somehow my initial patch was
picked up instead of the updated one.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 668682d..057fe60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2843,7 +2843,7 @@ M:	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
 L:	linux-i2c@vger.kernel.org
 W:	http://i2c.wiki.kernel.org/
 T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
-T:	git git://git.fluff.org/bjdooks/linux.git
+T:	git git://git.fluff.org/bjdooks/linux.git next-i2c
 S:	Maintained
 F:	Documentation/i2c/
 F:	drivers/i2c/
-- 
1.7.2.3

