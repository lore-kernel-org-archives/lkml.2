Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935890Ab0HFXCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:02:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab0HFXCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:02:41 -0400
Date: Fri, 6 Aug 2010 23:02:23 GMT
Message-Id: <201008062302.o76N2NFN016635@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for 2.6.36
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Joe Perches <joe@perches.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 23:02:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fc1caf6eafb30ea185720e29f7f5eccca61ecd60:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-08-05 16:02:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

Joe Perches (1):
      x86: Clean up arch/x86/kernel/cpu/mtrr/cleanup.c: use ";" not "," to terminate statements

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
