Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0EXAJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:09:32 -0400
Received: from xenotime.net ([72.52.115.56]:54820 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755721Ab0EXAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:08:04 -0400
Date: Sun, 23 May 2010 17:02:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 4/9] Documentation/timers/hpet_example: drop duplicate header files
Message-ID: <12746593503684@xenotime.net>
In-Reply-To: <12746593501290@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Gelmini <andrea.gelmini@gelma.net>

Documentation/timers/hpet_example.c: fcntl.h is included more than once.
Documentation/timers/hpet_example.c: signal.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/timers/hpet_example.c |    2 --
 1 file changed, 2 deletions(-)

--- lnx-2634-docs.orig/Documentation/timers/hpet_example.c
+++ lnx-2634-docs/Documentation/timers/hpet_example.c
@@ -10,7 +10,6 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <signal.h>
-#include <fcntl.h>
 #include <errno.h>
 #include <sys/time.h>
 #include <linux/hpet.h>
@@ -24,7 +23,6 @@ extern void hpet_read(int, const char **
 
 #include <sys/poll.h>
 #include <sys/ioctl.h>
-#include <signal.h>
 
 struct hpet_command {
 	char		*command;


-- 

