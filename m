Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0IMQiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:38:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab0IMQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:38:23 -0400
MIME-Version: 1.0
In-Reply-To: <20100913161641.GA28707@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com>
 <1284231470.2251.52.camel@laptop> <20100911195708.GA9273@Krystal>
 <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal>
 <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop>
 <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop> <20100913161641.GA28707@Krystal>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Sep 2010 09:36:56 -0700
Message-ID: <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
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

On Mon, Sep 13, 2010 at 9:16 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> OK, the long IRC discussions we just had convinced me that the current scheme
> takes things into account by adapting the granularity dynamically, but also got
> me to notice that check_preempt seems to compare vruntime with wall time, which
> is utterly incorrect. So maybe all my patch was doing was to expose this bug:

Do you have latency numbers for this patch?

                    Linus
