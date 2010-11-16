Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab0KPWJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:09:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:8728 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab0KPWJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:09:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,207,1288594800"; 
   d="scan'208";a="349620516"
Message-ID: <4CE30108.7010207@linux.intel.com>
Date: Tue, 16 Nov 2010 14:09:12 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>	 <4CE2F747.4060406@linux.intel.com>  <20101116215940.GA13912@elte.hu> <1289945023.2109.672.camel@laptop>
In-Reply-To: <1289945023.2109.672.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 02:03 PM, Peter Zijlstra wrote:
> On Tue, 2010-11-16 at 22:59 +0100, Ingo Molnar wrote:
>>
>>
>> Would you be interested in helping out with (and testing) such a more generic
>> approach?
>
> how about having perf-record open a named pipe and rewriting everything
> that comes in through that as an event and storing it in the buffer?

When I'm tracing an app or test-case, I want to be able to quickly add 
and change strings. I like the trace_printk sort of access as it avoids 
having to do a bunch of string formatting (sprintf()) calls in the test app.

-- 
Darren Hart
Yocto Linux Kernel
