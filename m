Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0IMRwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:52:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272Ab0IMRwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:52:01 -0400
MIME-Version: 1.0
In-Reply-To: <20100913174533.GA15653@Krystal>
References: <1284231470.2251.52.camel@laptop> <20100911195708.GA9273@Krystal>
 <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal>
 <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop>
 <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop>
 <20100913161641.GA28707@Krystal> <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
 <20100913174533.GA15653@Krystal>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Sep 2010 10:51:38 -0700
Message-ID: <AANLkTi=8m4g01wZPacySoF7U0PevTNVgJoZZrHiUD-pN@mail.gmail.com>
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime with
 wall time
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:45 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> FWIW, Xorg and firefox feel _much more_ responsive with the fix I propose when
> running with a make -j10. The system is even usable with a make -j20 on my UP
> machine, even though I can start feeling a some lag. This is probably a more
> important, yet less scientific, result.

I'll test that myself (but in a bit - I need to go do voter
registration and socsec update first, though - I became a US citizen
last week).

Because yes, that's the reason I'm personally interested in your
scheduler latency work: I think our X behavior under load is pitiful
(I do "make -j16" on my dual-core with HT Core i5, and web browsong
shouldn't start to lag as much as it does just because I overcommit
the CPU a bit). So if this makes a noticeable difference, I think it's
very important.

                       Linus
