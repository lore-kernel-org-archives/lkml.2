Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2IYKeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:34:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53213 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2IYKeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:34:08 -0400
Message-ID: <1348569232.3881.1.camel@twins>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are
 onlined.
From: Peter Zijlstra <peterz@infradead.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org, wency@cn.fujitsu.com, mingo@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 25 Sep 2012 12:33:52 +0200
In-Reply-To: <50611946.9080601@cn.fujitsu.com>
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1348479536.11847.25.camel@twins> <50611946.9080601@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 10:39 +0800, Tang Chen wrote:
> >> @@ -6765,11 +6773,64 @@ static void sched_init_numa(void)
> >>      }
> >>
> >>      sched_domain_topology = tl;
> >> +
> >> +    sched_domains_numa_levels = level;
> 
> And I set it to level here again.
> 
But its already set there.. its set every time we find a new level.


