Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab0FVVL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:11:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab0FVVL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:11:56 -0400
Date: Tue, 22 Jun 2010 23:11:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Oleg Nesterov <oleg@redhat.com>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH RFC] reduce runqueue lock contention
Message-ID: <20100622211141.GC21149@elte.hu>
References: <20100520204810.GA19188@think>
 <1277114522.1875.469.camel@laptop>
 <1277117647.1875.503.camel@laptop>
 <1277125479.1875.510.camel@laptop>
 <1277213586.1875.704.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277213586.1875.704.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> So this one boots and builds a kernel on a dual-socket nehalem.
> 
> there's still quite a number of XXXs to fix, but I don't think any of the 
> races are crashing potential, mostly wrong accounting and scheduling iffies 
> like.
> 
> But give it a go.. see what it does for you (x86 only for now).
> 
> Ingo, any comments other than, eew, scary? :-)

None, other than a question: which future kernel do you aim it for? I'd prefer 
v2.6.50 or later ;-)

This is a truly scary patch.

	Ingo
