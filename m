Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2BEAYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:24:44 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10729 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2BEAYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:24:43 -0500
Date: Sun, 5 Feb 2012 01:25:10 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH] h8300: Remove trailing whitespace from
 arch/h8300/kernel/gpio.c
Message-ID: <alpine.LNX.2.00.1202050123210.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a bit of trivial whitespace cleanup.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/h8300/kernel/gpio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/h8300/kernel/gpio.c b/arch/h8300/kernel/gpio.c
index 6a25dd5..fdd823b 100644
--- a/arch/h8300/kernel/gpio.c
+++ b/arch/h8300/kernel/gpio.c
@@ -48,7 +48,7 @@ static volatile unsigned char *ddrs[] = {
 #define MAX_PORT 17
 #endif
 #undef _
- 
+
 #if !defined(P1DDR)
 #error Unsuppoted CPU Selection
 #endif
@@ -125,7 +125,7 @@ static char *port_status(int portno)
 	char *rp;
 	int c;
 	unsigned char used,ddr;
-	
+
 	used = gpio_regs[portno].used;
 	ddr  = gpio_regs[portno].ddr;
 	result[8]='\0';
@@ -133,12 +133,12 @@ static char *port_status(int portno)
 	for (c = 8; c > 0; c--,rp--,used >>= 1, ddr >>= 1)
 		if (used & 0x01)
 			*rp = io[ ddr & 0x01];
-		else	
+		else
 			*rp = '-';
 	return result;
 }
 
-static int gpio_proc_read(char *buf, char **start, off_t offset, 
+static int gpio_proc_read(char *buf, char **start, off_t offset,
                           int len, int *unused_i, void *unused_v)
 {
 	int c,outlen;
@@ -159,7 +159,7 @@ static __init int register_proc(void)
 	struct proc_dir_entry *proc_gpio;
 
 	proc_gpio = create_proc_entry("gpio", S_IRUGO, NULL);
-	if (proc_gpio) 
+	if (proc_gpio)
 		proc_gpio->read_proc = gpio_proc_read;
 	return proc_gpio != NULL;
 }
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

