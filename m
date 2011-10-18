Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab1JRP0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:26:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:60575 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab1JRP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:26:31 -0400
Date: Tue, 18 Oct 2011 17:26:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
In-Reply-To: <CA+55aFy5bpu_Aqp7HOtS3tLG5kQ9ut9qtpgM==DJBQ6s-51NEA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1110181724560.3240@ionos>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca> <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca> <1318060551.8395.0.camel@twins>
 <20111012213555.GC24461@hostway.ca> <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com> <1318847658.6594.40.camel@twins> <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
 <1318874090.4172.84.camel@twins> <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com> <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos> <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins>
 <CA+55aFy5bpu_Aqp7HOtS3tLG5kQ9ut9qtpgM==DJBQ6s-51NEA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Linus Torvalds wrote:

> On Tue, Oct 18, 2011 at 2:05 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > Subject: cputimer: Cure lock inversion
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Mon Oct 17 11:50:30 CEST 2011
> >
> > There's a lock inversion between the cputimer->lock and rq->lock; notably
> > the two callchains involved are:
> 
> Thanks, looks nice and small. Simon - can you check that this works for you?
> 
> Thomas/Ingo - once confirmed by Simon, should I take it directly or
> will this come through your trees?

I have it queued in timers/urgent and run it through testing at the
moment. Will send a pull request once confirmed.

Thanks,

	tglx

