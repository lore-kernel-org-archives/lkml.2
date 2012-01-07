Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2AGMf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 07:35:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab2AGMf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 07:35:58 -0500
Date: Sat, 7 Jan 2012 13:33:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/syscall changes for v3.3
Message-ID: <20120107123347.GA18966@elte.hu>
References: <20120105152918.GA12838@elte.hu>
 <20120106230526.088cb77546022ecda34aaae5@canb.auug.org.au>
 <4F077FA8.7060100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F077FA8.7060100@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 01/06/2012 04:05 AM, Stephen Rothwell wrote:
> > 
> > HPA has a pending fix for this patch as it causes warnings on
> > PowerPC at least.  The idea was to move this include of
> > asm/asm-offsets.h into asm/ftrace.h so it only affects x86.
> > 
> 
> Sorry... have been in baby mode for the past week, but yes, I 
> think it only causes warnings and it's a trivial fix.

Lets delay this tree nevertheless, the warnings seem numerous 
and annoying (and they've been reported), right?

Linus, please don't pull it for now.

Thanks,

	Ingo
