Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0CYRXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:23:21 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0CYRXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=hN8JQZCZSzeMxW93huSPQOdUuDSUUJZ+QhEmrIsPlo9atB8Zj7SbrwgVDVsG25y8mO
         IbkosufBYBUitPBj2LoHWsd14EWnK6Nzblh5coGT7rnayLh6uCpFSRBA3jrNjRAguCVc
         9Glf4BiSyn3bjrz44QNFGLmNck3BjhBfttO2U=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] Docs hpet_example.c: duplicated includes
Date: Thu, 25 Mar 2010 18:22:36 +0100
Message-Id: <1269537767-7553-6-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/timers/hpet_example.c: fcntl.h is included more than once.
Documentation/timers/hpet_example.c: signal.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/timers/hpet_example.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/timers/hpet_example.c b/Documentation/timers/hpet_example.c
index f9ce2d9..4bfafb7 100644
--- a/Documentation/timers/hpet_example.c
+++ b/Documentation/timers/hpet_example.c
@@ -10,7 +10,6 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <signal.h>
-#include <fcntl.h>
 #include <errno.h>
 #include <sys/time.h>
 #include <linux/hpet.h>
@@ -24,7 +23,6 @@ extern void hpet_read(int, const char **);
 
 #include <sys/poll.h>
 #include <sys/ioctl.h>
-#include <signal.h>
 
 struct hpet_command {
 	char		*command;
-- 
1.7.0.3.296.g9776a

