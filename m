Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab2KPHBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:01:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43327 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2KPHBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:01:54 -0500
Message-ID: <50A5E4D6.60301@gmail.com>
Date: Fri, 16 Nov 2012 08:01:42 +0100
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Jim Paris <jim@jtan.com>,
        "Michael Kerrisk (gmail)" <mtk.manpages@gmail.com>
Subject: [PATCH] Correct description of SwapFree in Documentation/filesystems/proc.txt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After migrating most of the information in 
Documentation/filesystems/proc.txt to the proc(5) man page,
Jim Paris pointed out to me that the description of SwapFree
in the man page seemed wrong. I think Jim is right,
but am given pause by fact that that text has been in 
Documentation/filesystems/proc.txt since at least 2.6.0.
Anyway, I believe that the patch below fixes things.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>


diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a1793d6..cf4260f 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -778,8 +778,7 @@ AnonHugePages:   49152 kB
               other things, it is where everything from the Slab is
               allocated.  Bad things happen when you're out of lowmem.
    SwapTotal: total amount of swap space available
-    SwapFree: Memory which has been evicted from RAM, and is temporarily
-              on the disk
+    SwapFree: Amount of swap space that is currently unused.
        Dirty: Memory which is waiting to get written back to the disk
    Writeback: Memory which is actively being written back to the disk
    AnonPages: Non-file backed pages mapped into userspace page tables
