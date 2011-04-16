Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab1DPMAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 08:00:44 -0400
Received: from 8bytes.org ([88.198.83.132]:57660 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759328Ab1DPMAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 08:00:38 -0400
Date: Sat, 16 Apr 2011 14:00:37 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexandre Demers <alexandre.f.demers@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110416120037.GQ18463@8bytes.org>
References: <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <4DA8535B.4080901@gmail.com> <20110415142724.GK18463@8bytes.org> <4DA895A2.4060307@gmail.com> <20110415190641.GA20770@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415190641.GA20770@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 09:06:41PM +0200, Ingo Molnar wrote:
> 
> * Alexandre Demers <alexandre.f.demers@gmail.com> wrote:
> 
> > On 11-04-15 10:27 AM, Joerg Roedel wrote:
> > > On Fri, Apr 15, 2011 at 10:16:59AM -0400, Alexandre Demers wrote:
> > >> Ok, I'll test it today. Should I apply it on a clean rc3 without any of
> > >> the other patches?
> > > Yes, apply it just on -rc3 without any other patch.
> > >
> > >> BTW, may I suggest adding the info under bug 33012 in kernel bugzilla?
> > >> This could be useful in the future.
> > > Cool, thanks
> > >
> > >
> > > 	Joerg
> > The patch was applied and tested. It looks fine, I'm able to boot
> > without problem.
> 
> Joerg, mind submitting it with a changelog that includes everything we learned 
> about this bug and all the Tested-by's in place?

Looks like I am too late, it is already applied. But the changelog
contains a link to the korg-bugzilla which has all information too. So
the information is not lost.

	Joerg

