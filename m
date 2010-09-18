Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0IRPxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 11:53:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55044 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0IRPxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 11:53:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Hn1/sJbvT2uEm8E8keTuTimH5kunZ9N1c0sF7Miih18HTUpl9gIUZo2fs4Z1+b8/CI
         H+fcqxfrnFdA+KApE/gO8kQaxAJ+tNRL6zalBbLbc6nQV6U3gp8BhpmjGqj4u9v1fdgs
         K224sk6u67c300gW0XIHMEpabYsQyEISsnjsk=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] printk: Fixup declaration of kmsg_reasons
Date: Sun, 19 Sep 2010 00:52:59 +0900
Message-Id: <1284825182-32588-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
References: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move redundant 'const' after '*' to make pointer itself const

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..a491251 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1511,7 +1511,7 @@ int kmsg_dump_unregister(struct kmsg_dumper *dumper)
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 
-static const char const *kmsg_reasons[] = {
+static const char * const kmsg_reasons[] = {
 	[KMSG_DUMP_OOPS]	= "oops",
 	[KMSG_DUMP_PANIC]	= "panic",
 	[KMSG_DUMP_KEXEC]	= "kexec",
-- 
1.7.0.4

