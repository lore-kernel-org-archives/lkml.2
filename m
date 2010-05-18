Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0ERABb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:01:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab0ERABa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:01:30 -0400
Date: Tue, 18 May 2010 02:00:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100518000052.GC20590@elte.hu>
References: <87tyq9mqrz.fsf@basil.nowhere.org>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
 <20100517102214.GA20761@basil.fritz.box>
 <a3572531-ca89-4959-b190-bcb9309a0193@defaultalpine.LFD.2.00.1005180022040.3368@localhost.localdomain>
 <b190a20b-6420-4bd0-a261-f66c520ae983@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b190a20b-6420-4bd0-a261-f66c520ae983@default>
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


* Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> OK, well ignoring the metaphor, it's clear we 
> disagree on a point that neither one of us can 
> prove: You think your decision to avoid sharing 
> kernel information will stop system programmers 
> from using rdtsc, and I think some are going to use 
> rdtsc anyway and blame Linux when something 
> eventually and silently breaks.

Applications can do various unreliable things, the 
kernel cannot do anything about that.

The point is for the kernel to not be complicit in 
practices that are technically not reliable.

So the kernel wont 'signal' that something is safe to 
use if it is not safe to use.

One suggestion in this thread makes sense i think: to 
signal via sysfs that gettimeofday is slow.

Plus lets hope that we really can figure out a fast, 
TSC based gettimeofday implementation. If that is 
possible then user-space will get a fast gettimeofday 
right out of box.

Thanks,

	Ingo
