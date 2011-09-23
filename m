Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1IWNZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:25:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:32816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1IWNZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:25:12 -0400
Subject: Re: [PATCH 19/21] tracing: Account for preempt off in
 preempt_schedule()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Sep 2011 15:24:41 +0200
In-Reply-To: <1316776749.29966.156.camel@gandalf.stny.rr.com>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221029.678324653@goodmis.org>  <1316775648.9084.1.camel@twins>
	 <1316776749.29966.156.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316784281.9084.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 07:19 -0400, Steven Rostedt wrote:
> Yes, that's the way git usually works

Its also one of the reasons I hate git. In this case the fixup will live
in some merge commit and be totally lost to the normal way of things.

I absolutely detest non empty merge commits.
