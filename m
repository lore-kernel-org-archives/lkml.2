Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab0JSWqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:46:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53760 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab0JSWqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:46:14 -0400
Message-ID: <4CBE1F5E.8040807@zytor.com>
Date: Tue, 19 Oct 2010 15:44:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
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
References: <4CBD79CF.2060706@jp.fujitsu.com> <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6> <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6> <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <20101019212816.GA2855@redhat.com> <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6> <20101019223842.GE2855@redhat.com>
In-Reply-To: <20101019223842.GE2855@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 03:38 PM, Jason Baron wrote:
> 
> I'm not sure I did, the documentation says that we have nop followed by
> a jmp:
> 
> +The new code is a 'nopl' followed by a 'jmp'. Thus:
> +
> +nopl - 0f 1f 44 00 00 - 5 bytes
> +jmp  - eb 3e          - 2 bytes
> 

There is no excuse for needing the second jump here, obviously...

	-hpa
