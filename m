Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2F3Wh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 18:37:59 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46273 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752745Ab2F3Wh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 18:37:58 -0400
Message-ID: <4FEF7FA4.3000903@xenotime.net>
Date: Sat, 30 Jun 2012 15:37:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] printk.c: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warnings in printk.c: use correct parameter name.

Warning(kernel/printk.c:2429): No description found for parameter 'buf'
Warning(kernel/printk.c:2429): Excess function parameter 'line' description in 'kmsg_dump_get_buffer'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-35-rc4.orig/kernel/printk.c
+++ lnx-35-rc4/kernel/printk.c
@@ -2409,7 +2409,7 @@ EXPORT_SYMBOL_GPL(kmsg_dump_get_line);
  * kmsg_dump_get_buffer - copy kmsg log lines
  * @dumper: registered kmsg dumper
  * @syslog: include the "<4>" prefixes
- * @line: buffer to copy the line to
+ * @buf: buffer to copy the line to
  * @size: maximum size of the buffer
  * @len: length of line placed into buffer
  *
