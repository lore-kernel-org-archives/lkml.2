Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227Ab2JYN7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:59:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41084 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161116Ab2JYN7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:59:48 -0400
Date: Thu, 25 Oct 2012 15:59:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Multiple patch authors (was: Re: [PATCH v3] Add support for AMD64
 EDAC on multiple PCI domains)
Message-ID: <20121025135948.GA308@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com>
 <20121025110353.GA2623@aftab.osrc.amd.com>
 <20121025115654.GA27611@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121025115654.GA27611@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:56:54PM +0200, Ingo Molnar wrote:
> No, SOBs are to document patch forwarding. Co-authorship can be
> expressed a number of ways, such as:
>
> Based-on-patch-from: Borislav Petkov <bp@alien8.de>
>
> and/or by adding you as a copyright holder to one of the files.

Ok, let's hold this down in writing for future reference and in case I
forget (which will happen, most probably :-)).

How about the following:

--
>From e28a8a940b219878d57add0d067a07764a6ef4a5 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@alien8.de>
Date: Thu, 25 Oct 2012 15:52:59 +0200
Subject: [PATCH] SubmittingPatches: Document multiple authorship

Put down the way to express multiple authorship in writing for future
reference.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 Documentation/SubmittingPatches | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index c379a2a6949f..f61b1d8b6f9c 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -339,6 +339,16 @@ then you just add a line saying
 
 using your real name (sorry, no pseudonyms or anonymous contributions.)
 
+In the case where two or more people work on one patch and contribute to
+its final version, stating multiple authorship should be expressed by
+adding the other co-authors of said patch to the tag chain like this:
+
+	Based-on-work-by: Second Author <second.author@example.org>
+	Based-on-work-by: Third Author  <third.author@example.org>
+
+Alternatively, the second, third, etc. authors can be credited as
+copyright holders in the files being changed.
+
 Some people also put extra tags at the end.  They'll just be ignored for
 now, but you can do this to mark internal company procedures or just
 point out some special detail about the sign-off. 
-- 
1.8.0

-- 
Regards/Gruss,
Boris.
