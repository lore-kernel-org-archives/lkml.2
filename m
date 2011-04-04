Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1DDTTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 15:19:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab1DDTTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:19:54 -0400
Date: Mon, 4 Apr 2011 21:19:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20110404191943.GA28258@elte.hu>
References: <20110402103125.GA18746@elte.hu>
 <BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I pulled this, but I think this:
> 
> On Sat, Apr 2, 2011 at 3:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > -               if (interval > HZ*NR_CPUS/10)
> > -                       interval = HZ*NR_CPUS/10;
> > +               if (interval > HZ*num_online_cpus()/10)
> > +                       interval = HZ*num_online_cpus()/10;
> 
> is a horrible patch.

Indeed, will fix it.

Thanks,

	Ingo
