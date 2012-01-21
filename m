Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2AUSEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:41 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:52028 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751155Ab2AUSEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:15 -0500
Message-ID: <4F1B0BD2.1070509@xenotime.net>
Date: Sat, 21 Jan 2012 11:02:42 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: [PATCH 5/14] kernel-doc: fix new warnings in debugfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warnings:

Warning(fs/debugfs/file.c:556): No description found for parameter 'nregs'
Warning(fs/debugfs/file.c:556): Excess function parameter 'mregs' description in 'debugfs_print_regs32'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-33-rc1.orig/fs/debugfs/file.c
+++ lnx-33-rc1/fs/debugfs/file.c
@@ -540,7 +540,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
  * debugfs_print_regs32 - use seq_print to describe a set of registers
  * @s: the seq_file structure being used to generate output
  * @regs: an array if struct debugfs_reg32 structures
- * @mregs: the length of the above array
+ * @nregs: the length of the above array
  * @base: the base address to be used in reading the registers
  * @prefix: a string to be prefixed to every output line
  *
