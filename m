Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0IVRam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:30:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0IVRal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:30:41 -0400
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jean Pihet <jean.pihet@newoldbits.com>, Thomas Renninger <trenn@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
In-Reply-To: <4C9A37AE.2010509@linux.intel.com>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	 <201009171736.14170.trenn@suse.de>	<20100917162412.GB3341@elte.hu>
	 <201009180026.59482.trenn@suse.de>
	 <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
	 <4C9A21AD.1000800@linux.intel.com>
	 <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
	 <4C9A2FB3.105@linux.intel.com> <1285173835.2275.1026.camel@laptop>
	 <4C9A37AE.2010509@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 19:30:29 +0200
Message-ID: <1285176629.2275.1033.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 10:06 -0700, Arjan van de Ven wrote:

> In this case we're talking about basically a suprious rename of 
> something that isn't really an improvement
> (because it makes it harder to subscribe to only one type of event)... 
> that's not a good thing.

People have been talking about more/more comprehensive power tracepoints
for a while, and I think that's a valid goal, if its really a rename I'm
sure you can work it out.

That said, I really didn't read this discussion much, but your stance
seems to be that any tracepoint you use must stay valid, and I object to
that.

What will do you do when we include a new scheduling policy and all the
scheduler tracepoints need to change? (yes that's really going to
happen)

I'm not going to carry double tracepoints, and I'm not going to not
merge that policy. 
