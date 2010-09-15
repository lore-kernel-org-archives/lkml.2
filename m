Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0IOJC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:02:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52742 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751703Ab0IOJC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:02:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18aUJAN6jkarImH3iwiPDBNWdT5lO8YO3oWoPXAHr
	vQByBiQs54TWF+
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
 forks) (v3)
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284539831.21727.6.camel@marge.simson.net>
References: <20100914202503.GA1496@Krystal>
	 <1284539831.21727.6.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 11:03:25 +0200
Message-Id: <1284541405.22863.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tangent: cgroups with classification user/pgid

taskset -c 3 ./wakeup-latency& sleep 30 && killall wakeup-latency
(taskset -c 3 make -j10 running)

maximum latency: 256.5 µs
average latency: 25.7 µs
missed timer events: 0

Rather spiffy for this case.

	-Mike

