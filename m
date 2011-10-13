Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1JMJBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:01:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab1JMJBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:01:24 -0400
Date: Thu, 13 Oct 2011 10:59:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2 v2] [GIT PULL][v3.2] tracing: queued updates
Message-ID: <20111013085936.GA13046@elte.hu>
References: <20111011152026.701326733@goodmis.org>
 <20111012081629.GA25086@elte.hu>
 <1318418515.13262.21.camel@gandalf.stny.rr.com>
 <1318425974.13262.26.camel@gandalf.stny.rr.com>
 <20111012162320.GA31857@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012162320.GA31857@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Tests are also looking good so far.

there's a cross-build failure on the m32r architecture:

/home/mingo/tip/kernel/trace/trace_clock.c:117: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'trace_counter'
/home/mingo/tip/kernel/trace/trace_clock.c: In function 'trace_clock_counter':
/home/mingo/tip/kernel/trace/trace_clock.c:126: error: implicit declaration of function 'atomic64_add_return'
/home/mingo/tip/kernel/trace/trace_clock.c:126: error: 'trace_counter' undeclared (first use in this function)
/home/mingo/tip/kernel/trace/trace_clock.c:126: error: (Each undeclared identifier is reported only once
/home/mingo/tip/kernel/trace/trace_clock.c:126: error: for each function it appears in.)

Thanks,

	Ingo
