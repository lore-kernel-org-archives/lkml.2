Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1IWLWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:22:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:59317 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1IWLWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:22:42 -0400
Subject: Re: [PATCH 19/21] tracing: Account for preempt off in
 preempt_schedule()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Sep 2011 13:22:16 +0200
In-Reply-To: <1316776749.29966.156.camel@gandalf.stny.rr.com>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221029.678324653@goodmis.org>  <1316775648.9084.1.camel@twins>
	 <1316776749.29966.156.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316776936.9084.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 07:19 -0400, Steven Rostedt wrote:

> What would you suggest? Just ignore the latencies that schedule
> produces, even though its been one of the top causes of latencies?

I would like to actually understand the issue first.. so far all I've
got is confusion.
