Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1DQUFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:05:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40430 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1DQUFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Bq0r5cR/y6ljwN9jgl++ljp6aS/hsxA3/nundo+IgnBZxnAKs6ncerNN90nxtCNJWO
         k2uUxrQxbDpOb63+uLBiw2bWvX9I0RwPne5YjL7gssS/d/bDFqCervQDM0xUWQHWhgE4
         jGOUwBsuBVKk6/IxFqjeWdX7/VGNjlYIBAlyM=
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: [PATCH 1/4] alpha: Don't force -Werror.
Date: Sun, 17 Apr 2011 13:05:23 -0700
Message-Id: <1303070726-32155-2-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303070726-32155-1-git-send-email-rth@twiddle.net>
References: <1303070726-32155-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are outstanding gcc 4.6 warnings that need to be cleaned up
in the subdirectory.  No sense forcing the issue immediately.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index 9bb7b85..7a6d908 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -4,7 +4,7 @@
 
 extra-y		:= head.o vmlinux.lds
 asflags-y	:= $(KBUILD_CFLAGS)
-ccflags-y	:= -Werror -Wno-sign-compare
+ccflags-y	:= -Wno-sign-compare
 
 obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
-- 
1.7.4.2

