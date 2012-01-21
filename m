Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab2AUSFD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:05:03 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:43773 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751539Ab2AUSE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:57 -0500
Message-ID: <4F1B0BFC.2010105@xenotime.net>
Date: Sat, 21 Jan 2012 11:03:24 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 14/14] docbook: fix sched source file names in device-drivers
 book
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix warning since kernel scheduler functions and kernel-doc
notation were moved to other files.

docproc: lnx-33-rc1/kernel/sched.c: No such file or directory

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 Documentation/DocBook/device-drivers.tmpl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- lnx-33-rc1.orig/Documentation/DocBook/device-drivers.tmpl
+++ lnx-33-rc1/Documentation/DocBook/device-drivers.tmpl
@@ -50,7 +50,9 @@
 
      <sect1><title>Delaying, scheduling, and timer routines</title>
 !Iinclude/linux/sched.h
-!Ekernel/sched.c
+!Ekernel/sched/core.c
+!Ikernel/sched/cpupri.c
+!Ikernel/sched/fair.c
 !Iinclude/linux/completion.h
 !Ekernel/timer.c
      </sect1>
