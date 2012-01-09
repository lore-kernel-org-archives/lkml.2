Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2AIOqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:46:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:42165 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab2AIOqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:46:22 -0500
Message-ID: <1326120367.2442.84.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Date: Mon, 09 Jan 2012 15:46:07 +0100
In-Reply-To: <CAKfTPtDM-L-AcHr_o44vmR9VYRvQqOyXuwEgnZ61d4pbDOPFUg@mail.gmail.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins>
	 <20120110001445.GA20542@linux-youquan.bj.intel.com>
	 <1326107563.2442.65.camel@twins>
	 <CAKfTPtDM-L-AcHr_o44vmR9VYRvQqOyXuwEgnZ61d4pbDOPFUg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 15:29 +0100, Vincent Guittot wrote:

> I'm also using sched_mc level for doing powersaving load balance on
> ARM platform and we have real benefits.

Right, I've never said that power aware balancing was without merit, I
know it matters (quite a lot for some).

> We might modify the way we choose between power or performance mode
> because it's not always a matter of gathering or spreading tasks on
> cpus but until we found a best interface it's the way to enable
> powersaving mode

Sure, it was the only interface available.

But I really want to get rid of the topology based knobs we have now,
preferably I even want to get rid of the multi-value thing.

pjt still needs to post his linsched rework *poke* *poke*, that should
give a good basis to rework most of this without regressing the world
and then some.

But even without that I think we can do better than we do currently.


