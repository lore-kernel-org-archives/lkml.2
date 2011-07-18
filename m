Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1GRTLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:11:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45609 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab1GRTK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:10:59 -0400
Date: Mon, 18 Jul 2011 21:10:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@mit.edu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Subject: Re: [tip:x86/vdso] x86-64: Allow alternative patching in the vDSO
Message-ID: <20110718191054.GA18359@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@mit.edu>, linux-tip-commits@vger.kernel.org,
	linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
	tglx@linutronix.de, hpa@linux.intel.com
References: <e73112e4381fff29e31b882c2d0856822edaea53.1310563276.git.luto@mit.edu>
 <tip-1b3f2a72bbcfdf92e368a44448c45eb639b05b5e@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-1b3f2a72bbcfdf92e368a44448c45eb639b05b5e@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 04:23:18AM +0000, tip-bot for Andy Lutomirski wrote:
> Commit-ID:  1b3f2a72bbcfdf92e368a44448c45eb639b05b5e
> Gitweb:     http://git.kernel.org/tip/1b3f2a72bbcfdf92e368a44448c45eb639b05b5e
> Author:     Andy Lutomirski <luto@mit.edu>
> AuthorDate: Wed, 13 Jul 2011 09:24:11 -0400
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 13 Jul 2011 11:23:07 -0700
> 
> x86-64: Allow alternative patching in the vDSO
> 
> This code is short enough and different enough from the module
> loader that it's not worth trying to share anything.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> Link: http://lkml.kernel.org/r/e73112e4381fff29e31b882c2d0856822edaea53.1310563276.git.luto@mit.edu
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

--
From: Borislav Petkov <bp@alien8.de>
Date: Mon, 18 Jul 2011 21:07:25 +0200
Subject: [PATCH] x86, vdso: Drop now wrong comment

Now that 1b3f2a72bbcfdf92e368a44448c45eb639b05b5e is in, it is very
important that the below lying comment be removed! :-)

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/vdso/vclock_gettime.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 8792d6e..6bc0e72 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -6,7 +6,6 @@
  *
  * The code should have no internal unresolved relocations.
  * Check with readelf after changing.
- * Also alternative() doesn't work.
  */
 
 /* Disable profiling for userspace code: */
-- 
1.7.5.3.401.gfb674

-- 
Regards/Gruss,
    Boris.
