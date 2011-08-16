Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1HPPUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:20:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53294 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1HPPUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:20:10 -0400
Message-ID: <4E4A8A2A.6080705@us.ibm.com>
Date: Tue, 16 Aug 2011 08:18:02 -0700
From: Nivedita Singhvi <niv@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
References: <1313232790.25267.7.camel@twins> <1313236135.4486.10.camel@marge.simson.net> <1313236713.25267.10.camel@twins> <1313243965.4486.36.camel@marge.simson.net> <20110813162735.GA2650@linux.vnet.ibm.com> <1313295821.6334.5.camel@marge.simson.net>  <4E4A7BE3.5090902@us.ibm.com> <1313507408.6321.4.camel@marge.simson.net>
In-Reply-To: <1313507408.6321.4.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Tue, 2011-08-16 at 07:17 -0700, Nivedita Singhvi wrote:
> 
>> Mike,
>>
>> Which test were you running? Because I'm not seeing it
>> on our x3550 M3..
> 
> -rt11 did not trip up just idling along like a couple earlier releases
> did, but did stall when I tried to run ltp realtime testcases.

Ack. I'll try to reproduce the stall on -11. I was only
running sched_jitter and sched_latency earlier in a loop.
I should run the whole shebang (but we really need to
axe some test crud out of there).


thanks,
Nivedita
