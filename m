Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab0IKTWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 15:22:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977Ab0IKTWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 15:22:03 -0400
MIME-Version: 1.0
In-Reply-To: <1284231470.2251.52.camel@laptop>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com>
 <1284231470.2251.52.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Sep 2010 12:21:06 -0700
Message-ID: <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with nr_running
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 11:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Not at all charmed, this look like random changes without conceptual
> integrity.

I wish people actually looked at the _numbers_ and reacted to them,
rather than argue theory.

Guys, we have cases of bad latency under load. That's a pretty
undeniable fact. Arguing against a patch because of some theoretical
issue without at all even acknowledging the latency improvements is, I
think, really bad form.

So please. Acknowledge the latency issue. And come up with better
patches, rather than just shoot down alternatives. Because if the
answer is just NAK with no alternative, then that answer is worthless.
No?

                       Linus
