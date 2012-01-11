Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2AKJLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:11:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:21818 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab2AKJLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:11:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94652066"
Subject: Re: [PATCH 1/3] net: use this_cpu_xxx replace percpu_xxx funcs
From: "Alex,Shi" <alex.shi@intel.com>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, eric.dumazet@gmail.com, cl@gentwo.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, tglx@linutronix.de,
        mingo@redhat.com, avi@redhat.com, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, kvm@vger.kernel.org, jeremy@xensource.com
In-Reply-To: <20120111.010331.2039534822545257440.davem@davemloft.net>
References: <1322793200.11530.33.camel@debian> <4ED8BD00.4000500@trash.net>
	 <1326271533.5695.242.camel@debian>
	 <20120111.010331.2039534822545257440.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Jan 2012 17:10:18 +0800
Message-ID: <1326273018.5695.264.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 01:03 -0800, David Miller wrote:
> From: "Alex,Shi" <alex.shi@intel.com>
> Date: Wed, 11 Jan 2012 16:45:33 +0800
> 
> >> >>>> percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
> >> >>>> for further code clean up.
> >> >>>>
> >> >>>> And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
> >> >>>> performance since __this_cpu_xxx has no redundant preempt_disable()
> >> >>>>
> >> >>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
> >> >>>> ---
> >> >>>>  net/netfilter/xt_TEE.c |   12 ++++++------
> >> >>>>  net/socket.c           |    4 ++--
> >> >>>>  2 files changed, 8 insertions(+), 8 deletions(-)
> >> >>>
> >> >>> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> >> >>>
> >> >>> Thanks !
> >> >>
> >> >> Anyone like to pick up this patch? or more comments for this? 
> >> > 
> >> > Kaber, David: 
> >> > I appreciate for your any comments on this. Could you like do me a
> >> > favor? 
> >> 
> >> No objections from me.
> > 
> > rend this patch for 3.2.0 kernel with Eric's Ack. 
> > 
> > David, do you have any concerns for this patch?  I will very appreciate
> > if it can met 3.3 open window. 
> 
> Please just submit it directly with the other this_cpu() patches:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks a lot! :) 


