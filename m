Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0F1Xqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:46:52 -0400
Received: from mail.perches.com ([173.55.12.10]:1375 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab0F1Xqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:46:51 -0400
Subject: [PATCH] arch/x86/kernel/cpu/mtrr/cleanup.c: Use ";" not "," to
 terminate statements
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jun 2010 16:46:48 -0700
Message-ID: <1277768808.29157.280.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed if pr_<level> becomes a bit more space efficient.

Signed-off-by: Joe Perches <joe@perches.com>
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


