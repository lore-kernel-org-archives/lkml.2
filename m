Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2IKXuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:50:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47052 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab2IKXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:50:39 -0400
Message-ID: <504FCE48.1050409@linaro.org>
Date: Tue, 11 Sep 2012 16:50:32 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: soft lockup - CPU#1 stuck for 1024s!
References: <20120909075927.GA13058@localhost> <504E1E19.9050106@linaro.org> <20120911234130.GA13382@localhost>
In-Reply-To: <20120911234130.GA13382@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091123-5806-0000-0000-0000197FDD92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 04:41 PM, Fengguang Wu wrote:
> On Mon, Sep 10, 2012 at 10:06:33AM -0700, John Stultz wrote:
>> On 09/09/2012 12:59 AM, Fengguang Wu wrote:
>>> Hi John,
>>>
>>> The below lockup warning pops up very occasionally in kvm guest
>>> kernels and it's bisected down to
>>>
>>>          commit 2a8c0883c3cfffcc148ea606e2a4e7453cd75e73
>>>          Author: John Stultz <john.stultz@linaro.org>
>>>          Date:   Fri Jul 13 01:21:56 2012 -0400
>>>
>>>              time: Move xtime_nsec adjustment underflow handling timekeeping_adjust
>>>
>>> [    8.340327] Freeing unused kernel memory: 460k freed
>>> [ 1107.515496] [sched_delayed] sched: RT throttling activated
>>> [ 1107.516439] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
>>
>> Thanks so much for sending this. One detail I'm curious about is
>> that these kernels from the Bug messages seem to be v3.6-rc1 or
>> earlier.
>>
>> Ingo had a fix 1d17d17484d40f2d5b35c79518597a2b25296996 ("time: Fix
>> adjustment cleanup bug in timekeeping_adjust") that landed in
>> 3.6-rc2
>>
>> Has this issue actually been seen on a 3.6-rc2+ kernel?
> Nope. I tested -rc5 for 10000+ boots and it's obviously free from the bug.
> Sorry for the noise!

No worries. Thanks so much for following up on this, and your continued 
testing!
-john

