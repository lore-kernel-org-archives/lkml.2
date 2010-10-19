Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0JSW67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:58:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59588 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab0JSW66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:58:58 -0400
Message-ID: <4CBE2261.4090107@zytor.com>
Date: Tue, 19 Oct 2010 15:57:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <4CBD79CF.2060706@jp.fujitsu.com>	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>	 <20101019132236.GA19197@Krystal>	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>	 <1287496495.16971.372.camel@gandalf.stny.rr.com>	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>	 <20101019142820.GA14520@Krystal>	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>	 <20101019212816.GA2855@redhat.com>	 <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6>	 <20101019223842.GE2855@redhat.com>  <4CBE1F5E.8040807@zytor.com> <1287529013.16971.537.camel@gandalf.stny.rr.com>
In-Reply-To: <1287529013.16971.537.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 03:56 PM, Steven Rostedt wrote:
>>
>> There is no excuse for needing the second jump here, obviously...
> 
> Now the trick is to tell gcc that.
> 

Yes.

	-hpa
