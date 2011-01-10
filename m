Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1AJWXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:23:14 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15823 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab1AJWXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:23:11 -0500
Date: Mon, 10 Jan 2011 23:23:10 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: devel@driverdev.osuosl.org
cc: linux-kernel@vger.kernel.org, Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] FT1000: remove duplicate inc of linux/slab.h
Message-ID: <alpine.LNX.2.00.1101102320170.32164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/slab.h is included twice in ft1000_dnld.c - remove duplicate.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ft1000_dnld.c |    1 -
 1 file changed, 1 deletion(-)

  compile tested only

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index 0bf398d..0f3f0ff 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -28,11 +28,10 @@
 #include <linux/slab.h>
 #include <linux/unistd.h>
 #include <linux/netdevice.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
-#include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/vmalloc.h>
 
 #include "ft1000_dev.h"


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

