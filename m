Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1INPtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:49:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:49731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab1INPty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48391497"
Message-ID: <4E70CD20.1010501@linux.intel.com>
Date: Wed, 14 Sep 2011 08:49:52 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
References: <20110914133034.687048806@chello.nl>  <20110914133750.739484417@chello.nl> <4E70C9B3.5080503@linux.intel.com> <1316014774.5040.29.camel@twins>
In-Reply-To: <1316014774.5040.29.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/14/2011 08:39 AM, Peter Zijlstra wrote:
> On Wed, 2011-09-14 at 08:35 -0700, Darren Hart wrote:
>> Missing here is what the value of state should be when
>> calling wake_up_list. 
> 
> Depends on what all you want to wake up :-) Would a reference to the
> comment of try_to_wake_up() be good enough?

I found it by following the calls as well, and any serious developer
could as well. I just find the kerneldoc headers to be very valuable as
reference and I like to encourage their use when I can. This isn't a
huge deal, just a nudge to see if it sticks ;)

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
