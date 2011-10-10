Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1JJGHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:07:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1JJGHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:07:20 -0400
Date: Mon, 10 Oct 2011 08:05:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20111010060537.GE32173@elte.hu>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
 <1316778523.9084.17.camel@twins>
 <20110923122014.GP6063@erda.amd.com>
 <1317716839.25926.12.camel@twins>
 <20111004085409.GA18566@elte.hu>
 <m2botwlnfk.fsf@firstfloor.org>
 <1317746709.32543.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317746709.32543.23.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2011-10-04 at 09:41 -0700, Andi Kleen wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > >
> > >  - Testable IBS user-space code a bit more prominently integrated
> > >    than having to go down into a cellar with no working lights and 
> > >    finding the code on display in tools/perf/Documentation/examples/ 
> > >    on the bottom of a locked filing cabinet stuck in a disused
> > >    lavatory with a sign on the door saying 'Beware of the Leopard.'
> > 
> > I looked at this for PEBS, and the best solution currently seems
> > to be a python script that works with perf script and does some post
> > processing to present the data as summary or individual samples.
> > I assume that could work for IBS too.
> > 
> > Comments?
> 
> I would much prefer perf {ibs,pebs} commands implemented in C, so 
> that normal people can change/improve them too.

The other issue is performance, obviously. So for core functionality 
we are pretty sure we want to offer to everyone C is the preferred 
form.

Scripting integration *in addition* to that is obviously welcome too.

Thanks,

	Ingo
