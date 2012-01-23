Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2AWWp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:45:58 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24667 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab2AWWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:45:57 -0500
Date: Mon, 23 Jan 2012 23:45:58 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] drivers/media/dvb/frontends/drxk_hard.c does not need to
 include linux/version.h
Message-ID: <alpine.LNX.2.00.1201232343591.8772@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unneeded include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/dvb/frontends/drxk_hard.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

 compile tested only

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 6980ed7..5ab5379 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -28,7 +28,6 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

