Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0KRNVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:21:22 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56841 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0KRNVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:21:21 -0500
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
 directory
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101118125307.GB5344@nowhere>
References: <20101118035803.453609353@goodmis.org>
	 <1290076866.2109.1305.camel@laptop>  <20101118125307.GB5344@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 14:21:26 +0100
Message-ID: <1290086486.2109.1512.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 13:53 +0100, Frederic Weisbecker wrote:
> 
> 
> An other solution, which have been talking with Thomas yesterday, would be
> to allow having a single fd for several perf_events at once. That would
> solve some problems when you have hundreds of events opened (think about
> wide tracing, or use of all individual syscalls).

I'm working on that, but that doesn't make me like this crap any more.
