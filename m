Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab2AKJGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:06:10 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51226 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab2AKJF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:05:59 -0500
Date: Wed, 11 Jan 2012 01:03:31 -0800 (PST)
Message-Id: <20120111.010331.2039534822545257440.davem@davemloft.net>
To: alex.shi@intel.com
Cc: kaber@trash.net, eric.dumazet@gmail.com, cl@gentwo.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, tglx@linutronix.de,
        mingo@redhat.com, avi@redhat.com, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, kvm@vger.kernel.org, jeremy@xensource.com
Subject: Re: [PATCH 1/3] net: use this_cpu_xxx replace percpu_xxx funcs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326271533.5695.242.camel@debian>
References: <1322793200.11530.33.camel@debian>
	<4ED8BD00.4000500@trash.net>
	<1326271533.5695.242.camel@debian>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 11 Jan 2012 01:03:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alex,Shi" <alex.shi@intel.com>
Date: Wed, 11 Jan 2012 16:45:33 +0800

>> >>>> percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
>> >>>> for further code clean up.
>> >>>>
>> >>>> And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
>> >>>> performance since __this_cpu_xxx has no redundant preempt_disable()
>> >>>>
>> >>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> >>>> ---
>> >>>>  net/netfilter/xt_TEE.c |   12 ++++++------
>> >>>>  net/socket.c           |    4 ++--
>> >>>>  2 files changed, 8 insertions(+), 8 deletions(-)
>> >>>
>> >>> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
>> >>>
>> >>> Thanks !
>> >>
>> >> Anyone like to pick up this patch? or more comments for this? 
>> > 
>> > Kaber, David: 
>> > I appreciate for your any comments on this. Could you like do me a
>> > favor? 
>> 
>> No objections from me.
> 
> rend this patch for 3.2.0 kernel with Eric's Ack. 
> 
> David, do you have any concerns for this patch?  I will very appreciate
> if it can met 3.3 open window. 

Please just submit it directly with the other this_cpu() patches:

Acked-by: David S. Miller <davem@davemloft.net>
