Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1JRSJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:09:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1JRSJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:09:36 -0400
Date: Tue, 18 Oct 2011 20:07:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111018180751.GA18590@elte.hu>
References: <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <1318847658.6594.40.camel@twins>
 <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
 <1318874090.4172.84.camel@twins>
 <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
 <1318879396.4172.92.camel@twins>
 <alpine.LFD.2.02.1110172237030.3240@ionos>
 <alpine.LFD.2.02.1110181037120.3240@ionos>
 <1318928713.21167.4.camel@twins>
 <CA+55aFy5bpu_Aqp7HOtS3tLG5kQ9ut9qtpgM==DJBQ6s-51NEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy5bpu_Aqp7HOtS3tLG5kQ9ut9qtpgM==DJBQ6s-51NEA@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

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

Yeah, we have it in -tip already and it was tested all day, lemme 
cook up a pull request to not hold up the v3.1 release much longer..

Thanks,

	Ingo
