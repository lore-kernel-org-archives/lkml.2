Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0JSXKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:10:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47418 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab0JSXKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:10:40 -0400
Message-ID: <4CBE251A.6070603@zytor.com>
Date: Tue, 19 Oct 2010 16:09:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <20101019132236.GA19197@Krystal>	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>	 <1287496495.16971.372.camel@gandalf.stny.rr.com>	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>	 <20101019142820.GA14520@Krystal>	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>	 <1287521757.16971.397.camel@gandalf.stny.rr.com>	 <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6>	 <1287523439.16971.433.camel@gandalf.stny.rr.com>	 <4CBE122B.9020807@zytor.com> <20101019224126.GD3519@Krystal>	 <4CBE206A.20702@zytor.com> <1287529515.16971.538.camel@gandalf.stny.rr.com>
In-Reply-To: <1287529515.16971.538.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 04:05 PM, Steven Rostedt wrote:
>>
>> JMP/Jcc does have a consumer -- the IP -- and actually measuring shows
>> that it is much, much worse than NOP and other dummy instructions.
> 
> But how does JMP vs Jcc compare?
> 

*As far as I know* they're the same, except of course that a direct JMP
never mispredicts.

	-hpa
