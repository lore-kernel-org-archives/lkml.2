Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1CCMF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:05:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40098 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446Ab1CCMFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:05:23 -0500
Date: Thu, 3 Mar 2011 13:05:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86, amd-nb: Misc correctness fixes
Message-ID: <20110303120504.GA28508@elte.hu>
References: <20110302193855.GA3840@aftab>
 <20110303091440.GA18252@elte.hu>
 <20110303115932.GA8603@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303115932.GA8603@aftab>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Thu, Mar 03, 2011 at 04:14:40AM -0500, Ingo Molnar wrote:
> > I'm confused about the title - a 'correctness fix' is one that fixes an actual bug.
> > 
> > Did you mean 'cleanliness fixes'?
> 
> Yes sir, this is basically a result from the 'make W=1 ..' thing I've
> been playing with lately. Fixed.
> 
> > Also, checkpatch outputs a warning that looks legit.
> 
> Won't happen again. Hadn't enabled the pre-commit hook for checkpatch on
> that machine. Fixed.

Note that there are checkpatch warnings that are crappy - especially the col80 ones 
tend to produce 'fixes' that are far worse than the offense. So it's not an 
automatism, it's a case by case tool.

> Here's a better version:

Applied, thanks!

	Ingo
