Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab1AFA3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:37 -0500
Received: from kroah.org ([198.145.64.141]:35622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab1AFA3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:33 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002300.798350317@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [044/152] sparc64: Delete prom_puts() unused.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit ce05a94efaf71d562eeefd30d6bbc2ab42b06bac ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/prom/console_64.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/arch/sparc/prom/console_64.c
+++ b/arch/sparc/prom/console_64.c
@@ -81,19 +81,3 @@ prom_putchar(char c)
 {
 	prom_nbputchar(c);
 }
-
-void
-prom_puts(const char *s, int len)
-{
-	unsigned long args[7];
-
-	args[0] = (unsigned long) "write";
-	args[1] = 3;
-	args[2] = 1;
-	args[3] = (unsigned int) prom_stdout;
-	args[4] = (unsigned long) s;
-	args[5] = len;
-	args[6] = (unsigned long) -1;
-
-	p1275_cmd_direct(args);
-}


