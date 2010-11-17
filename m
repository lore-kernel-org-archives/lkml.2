Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab0KQNKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:10:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:48235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab0KQNKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:10:00 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101117150516.18136834@deb0>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117144758.38bf4f05@deb0> <1289998312.2109.745.camel@laptop>
	 <20101117150516.18136834@deb0>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 14:10:13 +0100
Message-ID: <1289999413.2109.758.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:05 +0200, Török Edwin wrote:
> On Wed, 17 Nov 2010 13:51:52 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-11-17 at 14:47 +0200, Török Edwin wrote:
> > > I see --call-graph in the trace record -h output, but it doesn't
> > > seem to work on x86_64 for me.
> > 
> > If you want to unwind userspace you need to build everything with
> > framepointers -- sadly some people have been lobbying to remove
> > framepointers from all distro builds, even though on x86_64 its nearly
> > free (i386 does have a significant performance benefit, sadly).
> > 
> > There's some work on-going to simply copy out the top of stack and let
> > dwarves go wild at it in userspace, but that isn't done yet.
> 
> Even without frame-pointers I should see at least the first caller in
> userspace, since that can be obtained by reading the return address of
> the syscall, right?

Right.

> I don't see any difference in the output of 'trace report' thats why
> I'm asking it is implemented at all right now, or I need additional
> flags to see it.

Ah, I haven't actually looked at any of the perf-trace code yet, so I'm
afraid I can't answer that particular question.

> I do see some difference in output of 'perf record -g/perf report'
> though.

ok.


