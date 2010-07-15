Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab0GOQZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:25:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:45983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694Ab0GOQZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:25:03 -0400
Date: Thu, 15 Jul 2010 16:24:40 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1277768808.29157.280.camel@Joe-Laptop.home>
References: <1277768808.29157.280.camel@Joe-Laptop.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Clean up arch/x86/kernel/cpu/mtrr/cleanup.c: use ";" not "," to terminate statements
Message-ID: <tip-b2691085d1f3ccce641dcfdd02722ba5d34db6ba@git.kernel.org>
Git-Commit-ID: b2691085d1f3ccce641dcfdd02722ba5d34db6ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Jul 2010 16:24:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2691085d1f3ccce641dcfdd02722ba5d34db6ba
Gitweb:     http://git.kernel.org/tip/b2691085d1f3ccce641dcfdd02722ba5d34db6ba
Author:     Joe Perches <joe@perches.com>
AuthorDate: Mon, 28 Jun 2010 16:46:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Jul 2010 18:21:22 +0200

x86: Clean up arch/x86/kernel/cpu/mtrr/cleanup.c: use ";" not "," to terminate statements

Also needed if pr_<level> becomes a bit more space efficient.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
LKML-Reference: <1277768808.29157.280.camel@Joe-Laptop.home>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 06130b5..c5f59d0 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -632,9 +632,9 @@ static void __init mtrr_print_out_one_result(int i)
 	unsigned long gran_base, chunk_base, lose_base;
 	char gran_factor, chunk_factor, lose_factor;
 
-	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
-	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
-	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
+	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor);
+	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor);
+	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor);
 
 	pr_info("%sgran_size: %ld%c \tchunk_size: %ld%c \t",
 		result[i].bad ? "*BAD*" : " ",
