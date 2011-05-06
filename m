Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1EFIyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:54:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1EFIyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:54:43 -0400
Date: Fri, 6 May 2011 10:54:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Liao <phyomh@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
Message-ID: <20110506085438.GA928@elte.hu>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
 <20110307180619.GG1873@nowhere>
 <AANLkTi=rabeXE6m0wRo029jgqHLBaUGQcXYJriLewZeJ@mail.gmail.com>
 <20110310024355.GG2533@nowhere>
 <AANLkTikZxDyL-SW7FFbEd4skMNTVWeh7mGDTXfWkvEMR@mail.gmail.com>
 <20110311115657.GB1826@nowhere>
 <AANLkTimaxPJCkA3TuDQKCvDXtqTrUb8vyrNqRRSzvYwb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimaxPJCkA3TuDQKCvDXtqTrUb8vyrNqRRSzvYwb@mail.gmail.com>
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


* Sam Liao <phyomh@gmail.com> wrote:

> > It depends if you select reverse callchain or not:
> >
> > $ perf report -s caller
> >
> > That will report main and kernel_thread as hists, and regular callee -> caller callchains.
> > Hence under main hist, you'll a lot of callchain starting from random points and all
> > ending in main!
> >
> > $ perf report -s caller -g caller
> >
> > That will report main and kernel_thread as hists, with callchains starting from
> > main under main.
> >
> > It becomes interesting when you want more granularity with -s caller,dso if we bring a way
> > to push forward the entrypoint one day. I suspect even more sorting combinations are
> > going to be interesting.
> >
> 
> Thanks for clarification. I'll try to come up with patches as you talked.

I'm wondering, is there any progress with this feature? Having sysprof-alike 
reverse ordering for call chains is a really powerful form of visualization 
IMO.

Thanks,

	Ingo
