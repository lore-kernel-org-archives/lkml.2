Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab1DJRWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 13:22:15 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10395 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab1DJRWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 13:22:12 -0400
Date: Sun, 10 Apr 2011 19:22:34 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Alan Cox <alan@linux.intel.com>
cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH][Trivial] Serial, ifx6x60c: Remove duplicate includes of
 linux/tty.h
Message-ID: <alpine.LNX.2.00.1104101919210.17706@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including linux/tty.h 3 times is a little over the top - once will do.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ifx6x60.c |    2 --
 1 file changed, 2 deletions(-)

	compile tested only.

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 8ee5a41..5315525 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -41,7 +41,6 @@
 #include <linux/tty.h>
 #include <linux/device.h>
 #include <linux/spi/spi.h>
-#include <linux/tty.h>
 #include <linux/kfifo.h>
 #include <linux/tty_flip.h>
 #include <linux/timer.h>
@@ -56,7 +55,6 @@
 #include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/wait.h>
-#include <linux/tty.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/spi/ifx_modem.h>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

