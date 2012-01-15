Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2AOUjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:39:16 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23876 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2AOUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:39:15 -0500
Date: Sun, 15 Jan 2012 21:39:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-media@vger.kernel.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Oliver Endriss <o.endriss@gmx.de>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH] Remove pointless linux/version.h include from
 drivers/media/dvb/frontends/tda18271c2dd.c
Message-ID: <alpine.LNX.2.00.1201152137261.13389@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by 'make versioncheck', there's no need for
drivers/media/dvb/frontends/tda18271c2dd.c to
#include <linux/version.h>, so this patch removes the include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/dvb/frontends/tda18271c2dd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 1b1bf20..fbd108e 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -29,7 +29,6 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

