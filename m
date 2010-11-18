Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab0KRNga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:36:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39890 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab0KRNg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qPQdRPXgySsD2EZjdbW1JVkWIeU9hC2BW9/6Sg+3sBQSLxjZEKCzE/vAHxLGnLhqmn
         yJ3ef7NPhqjZ56iCJ6RAIF1EFRcSIecu+cJ6uGH9Guh2wFJjVE4PDKD3Lt3pMfjf8BGl
         6+XOhkQHyHlMYu5CQrwN6jtvlFAefWrOXLJ3g=
Date: Thu, 18 Nov 2010 14:36:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
	directory
Message-ID: <20101118133622.GC5344@nowhere>
References: <20101118035803.453609353@goodmis.org> <1290076866.2109.1305.camel@laptop> <20101118125307.GB5344@nowhere> <1290086486.2109.1512.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290086486.2109.1512.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:21:26PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 13:53 +0100, Frederic Weisbecker wrote:
> > 
> > 
> > An other solution, which have been talking with Thomas yesterday, would be
> > to allow having a single fd for several perf_events at once. That would
> > solve some problems when you have hundreds of events opened (think about
> > wide tracing, or use of all individual syscalls).
> 
> I'm working on that, but that doesn't make me like this crap any more.


No problem, we have more important things to focus on for now anyway.
We may unearth it one day if the context makes it more useful.

Thanks.

