Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1A2KhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 05:37:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1A2KhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 05:37:21 -0500
Date: Sat, 29 Jan 2011 11:37:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, roland@redhat.com,
        jan.kratochvil@redhat.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: Bash not reacting to Ctrl-C
Message-ID: <20110129103703.GA13189@elte.hu>
References: <AANLkTimKhrCvyzmGsogxWUOsgiek1vnQ17Tjnhm0T=LM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimKhrCvyzmGsogxWUOsgiek1vnQ17Tjnhm0T=LM@mail.gmail.com>
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


* julie Sullivan <kernelmail.jms@gmail.com> wrote:

> (apologies for not replying to original thread, I wasn't subscribed)
> 
> >Might be some Bash assumption or race that works under other OSs but somehow Linux
> >does differently. IIRC Bash is being developed on MacOS-X.
> 
> Yep, and I can confirm that this behaviour is the same on MacOS-X too
> (I tested Ingo's
> bash scripts in my break on a machine at work today).
> Ctrl-C is lost about once in every 10 times.

Ok, so it's likely a Bash bug.

[ It's annoying nevertheless :) ]

> >See that '^C^C' line? That is where i had to do Ctrl-C twice.
> 
> I beat Ingo - I got three '^C's in a row on the Mac a couple of times :-)

:-)

Thanks,

	Ingo
