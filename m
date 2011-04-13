Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1DMRtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:49:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1DMRtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:49:24 -0400
Date: Wed, 13 Apr 2011 19:49:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frank Arnold <farnold@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up mwait_play_dead
Message-ID: <20110413174909.GB9619@elte.hu>
References: <1302711073-31985-1-git-send-email-farnold@amd64.org>
 <4DA5D4D8.7000902@zytor.com>
 <20110413173634.GA1904@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413173634.GA1904@gere.osrc.amd.com>
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

> On Wed, Apr 13, 2011 at 09:52:40AM -0700, H. Peter Anvin wrote:
> > On 04/13/2011 09:11 AM, Frank Arnold wrote:
> > > From: Frank Arnold <frank.arnold@amd.com>
> > > 
> > > Commit 93789b32dbf355e70f18b17a82e8661677a7f7fb introduced
> > > cpuinfo_x86 *c for brevity. It is used to check for the
> > > mwait feature flag. The same can be done with a subsequent
> > > check for clflsh and save us a second per-cpu pointer
> > > dereference.
> > > 
> > > Signed-off-by: Frank Arnold <frank.arnold@amd.com>
> > > Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> > > ---
> > >  arch/x86/kernel/smpboot.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > 
> > This should be using this_cpu_has()... if that's not in the tree yet we
> > should add it.
> 
> Looks like it is still in tip/x86/mm.

Yeah - that patch was sent at around the beginning of the merge window, so it 
was too late for .39.

> We could either redo the patch properly when this_cpu_has() is merged or add 
> the change against that branch.

Yeah - please do one against tip:master and we'll put it into the right topic 
branch.

Thanks,

	Ingo
