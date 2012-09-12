Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab2ILQHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:07:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40708 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760188Ab2ILQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:07:28 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH] MAINTAINERS: fix tree for current i2c-embedded development
Date: Wed, 12 Sep 2012 18:07:00 +0200
Message-Id: <1347466020-11836-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guide people to where their patches can be found these days.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fdc0119..53cc13c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3388,7 +3388,7 @@ M:	"Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
 L:	linux-i2c@vger.kernel.org
 W:	http://i2c.wiki.kernel.org/
 T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
-T:	git git://git.fluff.org/bjdooks/linux.git
+T:	git git://git.pengutronix.de/git/wsa/linux.git
 S:	Maintained
 F:	Documentation/i2c/
 F:	drivers/i2c/
-- 
1.7.10.4

