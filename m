Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0IOJkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:40:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50391 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab0IOJku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:40:50 -0400
Message-ID: <4C909530.1070808@cn.fujitsu.com>
Date: Wed, 15 Sep 2010 17:43:12 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
        David Miller <davem@davemloft.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, dipankar@in.ibm.com
Subject: Re: [PATCH, RFC] RCU: New scalable, multi-GP and preemptible RCU
 implementation
References: <4C7B7A80.2040105@cn.fujitsu.com> <20100830235705.GQ2420@linux.vnet.ibm.com> <4C7C70EF.5020507@cn.fujitsu.com> <20100908195310.GA10797@linux.vnet.ibm.com> <4C8E18C1.7060806@cn.fujitsu.com> <20100913231756.GB18902@linux.vnet.ibm.com>
In-Reply-To: <20100913231756.GB18902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 07:17 AM, Paul E. McKenney wrote:
>>>>
>>>> Only in x86(32bit and 64bit) system.
>>>> Did you patch it in power and test it? It' need more test for different archs,
>>>> but I have no other arch.
>>>>
>>>> What is "hardware configuration"?
>>>
>>> Mainly the number of CPUs.  The socket/core/thread counts could also
>>> be helpful.
> 
> Any info?  ;-)
> 

Ouch, answer this first:
hardware1: x86,     1cpu X 2cores
hardware2: x86_64,  2cpu X 2cores
48 hours rcutorture for each machine, (NO_HZ, cpu_plugin concurrently ... )
~120 minutes rcutorture for each different CONFIG.

this work is my own work, not my company's, I can't access to
big machines.

Lai.
