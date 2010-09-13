Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0IMMxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:53:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0IMMxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:53:19 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100912203712.GD32327@Krystal>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 14:53:07 +0200
Message-ID: <1284382387.2275.265.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-12 at 16:37 -0400, Mathieu Desnoyers wrote:
> The whole point of my patch is not to have to do this latency vs performance
> tradeoff for low number of running threads. With your approach, lowering the
> granularity even when there are few threads running will very likely hurt
> performance, no ? 

But you presented it as a latency patch, not a throughput patch. And I'm
not sure it will matter enough to offset the computational cost it
introduces.


