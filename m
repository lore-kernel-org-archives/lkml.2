Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab1BPIiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:38:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1BPIh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:37:59 -0500
Date: Wed, 16 Feb 2011 09:37:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, George Spelvin <linux@horizon.com>,
        a.p.zijlstra@chello.nl, dzickus@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Message-ID: <20110216083747.GF16529@elte.hu>
References: <4D484853.9020409@gmail.com>
 <20110202023610.3799.qmail@science.horizon.com>
 <AANLkTi=X8vCuVOCMBJiCOB-8GZRF4-5RVx59QchecLz4@mail.gmail.com>
 <AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
 <AANLkTikx-7zJZaV2tgP=D=vZ12Brp9qrnyxLv_mVXQT3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikx-7zJZaV2tgP=D=vZ12Brp9qrnyxLv_mVXQT3@mail.gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On 2/16/11, Dave Airlie <airlied@gmail.com> wrote:
> > On Wed, Feb 2, 2011 at 2:18 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> >> On 2/2/11, George Spelvin <linux@horizon.com> wrote:
> >>>>  But if you have a will or would like to help debug the problem -- mind
> >>>> to
> >>>> try the patch below? Note the patch is ugly at moment and must *not* be
> >>>> running on non-P4 system (and I only compile-tested it so no guarantees
> >>>> at all, and I've CC'ed a couple of people as well)
> >>>
> >>> Promising...  After 32 minute of uptime, no NMI complaints so far.
> >>>
> >>> I'll let it run overnight and see what happens.
> >>>
> >>
> >> Great, thanks. Though the patch didn't help for Don, ie there is still
> >> an issue which needs to be resolved as well.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >
> > Ping on this problem, still seeing
> >
> > Uhhuh. NMI received for unknown reason 3c on CPU 0.
> > Do you have a strange power saving mode enabled?
> > Dazed and confused, but trying to continue
> >
> > on my Pentium-D system here with latest Linus head.
> >
> > its sometimes 3c, sometimes 3d, I'm going to bisect and push for
> > reverts if nobody still has any clue about how to fix this.
> >
> > Dave.
> >
> 
> We still trying to resolve it but without success yet. There is no
> easy way to revert it. One of the option might be to disable perf on
> p4 for a while. If this is acceptable -- i'll cook such patch and send
> it to Ingo. Hm?

That's not really acceptable - need to fix it or revert it to the last working 
state. Which commit broke it?

Thanks,

	Ingo
