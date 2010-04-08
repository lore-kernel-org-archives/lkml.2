Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab0DHH1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:27:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53701 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758509Ab0DHH1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:27:47 -0400
Date: Thu, 8 Apr 2010 09:27:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai <yinghai.lu@oracle.com>
Cc: James Morris <jmorris@namei.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100408072731.GA29866@elte.hu>
References: <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
 <20100331185916.GA12306@elte.hu>
 <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
 <4BB3DC4E.7030504@zytor.com>
 <alpine.LRH.2.00.1004011042460.32618@tundra.namei.org>
 <4BB3DF46.8080008@zytor.com>
 <alpine.LRH.2.00.1004011200020.365@tundra.namei.org>
 <20100401125210.GA2445@elte.hu>
 <20100408063236.GA23489@elte.hu>
 <4BBD7F18.1070205@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBD7F18.1070205@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai <yinghai.lu@oracle.com> wrote:

> On 04/07/2010 11:32 PM, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >> * James Morris <jmorris@namei.org> wrote:
> >>
> >>> On Wed, 31 Mar 2010, H. Peter Anvin wrote:
> >>>
> >>>> On 03/31/2010 04:43 PM, James Morris wrote:
> >>>>>>
> >>>>>> Upgraded how?  The problem no longer happens?
> >>>>>
> >>>>> Upgraded to the latest rawhide userland -- I have not since tested with 
> >>>>> bootmem off.  I'll try and do so again when I get a chance.
> >>>>>
> >>>>
> >>>> That would be great.  The sooner the better, obviously.
> >>>
> >>> I'm not seeing any problems now, with current Linus and rawhide.  I'll leave 
> >>> bootmem off and see if anything comes up again.
> >>
> >> (a current bootlog would still be nice)
> >>
> >> Dave, can you reproduce any of these problems with Linus's latest?
> > 
> > ping? Can you or Dave reproduce the bug with -rc3 or later kernels? (If not 
> > then it probably means that the bug you triggered was already fixed at the 
> > time you reported it, as hpa suspected.)
> 
> James already reported -rc3 fix the problem for him.
> 
> Dave implied -rc3 fixed problem for him

Hm, i'm confused, does this mean that it was all fixed upstream already when 
Dave and James sent their complaints?

Would be nice to have a confirmation from Dave for that (beyond 'implying' 
it), to not keep this thread open-ended.

Thanks,

	Ingo
