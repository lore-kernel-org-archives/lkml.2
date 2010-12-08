Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0LHMM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 07:12:29 -0500
Received: from canuck.infradead.org ([134.117.69.58]:34296 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab0LHMM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 07:12:28 -0500
Subject: Re: [RFC][PATCH 2/2 v2] tracing: Only trace sched_wakeup if it
 actually work something up
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <20101203040822.473086528@goodmis.org>
References: <20101203040358.955427199@goodmis.org>
	 <20101203040822.473086528@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 13:12:10 +0100
Message-ID: <1291810330.28378.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 23:04 -0500, Steven Rostedt wrote:
> Currently the tracepoint sched_wakeup traces the wakeup event even
> if the wakeup failed to wake anything up. This is quite stupid
> but it happens because we did not want to add a conditional
> to the core kernel code that would just slow down the wakeup events.
> 
Its actually quite useful at times, so no, I don't much like this.


