Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1DPMWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 08:22:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab1DPMWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 08:22:10 -0400
Date: Sat, 16 Apr 2011 14:21:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Alexandre Demers <alexandre.f.demers@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110416122149.GA22859@elte.hu>
References: <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
 <4DA655E7.3000904@zytor.com>
 <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com>
 <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
 <20110415131152.GJ18463@8bytes.org>
 <4DA8535B.4080901@gmail.com>
 <20110415142724.GK18463@8bytes.org>
 <4DA895A2.4060307@gmail.com>
 <20110415190641.GA20770@elte.hu>
 <20110416120037.GQ18463@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110416120037.GQ18463@8bytes.org>
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


* Joerg Roedel <joro@8bytes.org> wrote:

> On Fri, Apr 15, 2011 at 09:06:41PM +0200, Ingo Molnar wrote:
> > 
> > * Alexandre Demers <alexandre.f.demers@gmail.com> wrote:
> > 
> > > On 11-04-15 10:27 AM, Joerg Roedel wrote:
> > > > On Fri, Apr 15, 2011 at 10:16:59AM -0400, Alexandre Demers wrote:
> > > >> Ok, I'll test it today. Should I apply it on a clean rc3 without any of
> > > >> the other patches?
> > > > Yes, apply it just on -rc3 without any other patch.
> > > >
> > > >> BTW, may I suggest adding the info under bug 33012 in kernel bugzilla?
> > > >> This could be useful in the future.
> > > > Cool, thanks
> > > >
> > > >
> > > > 	Joerg
> > > The patch was applied and tested. It looks fine, I'm able to boot
> > > without problem.
> > 
> > Joerg, mind submitting it with a changelog that includes everything we learned 
> > about this bug and all the Tested-by's in place?
> 
> Looks like I am too late, it is already applied. But the changelog
> contains a link to the korg-bugzilla which has all information too. So
> the information is not lost.

Yeah. In this case getting the fix into -rc4 in a timely manner looked more 
important than waiting for an updated changelog :-)

Thanks,

	Ingo
