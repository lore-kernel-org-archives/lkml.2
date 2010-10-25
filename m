Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0JYFwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 01:52:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:65152 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0JYFwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 01:52:07 -0400
Message-ID: <4CC51C7C.3050400@windriver.com>
Date: Mon, 25 Oct 2010 13:58:20 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix possible divide-by-zero in	perf_swevent_overflow()
References: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com> <1282824727.1975.747.camel@laptop> <4C765FD3.9060904@windriver.com> <1282827486.1975.845.camel@laptop> <4C77ADC1.5030502@windriver.com> <1282913445.1975.2414.camel@laptop> <4C77BB6B.9090706@windriver.com> <20100827133735.GC5241@nowhere>
In-Reply-To: <20100827133735.GC5241@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 05:51:18.0282 (UTC) FILETIME=[A4C056A0:01CB7408]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Aug 27, 2010 at 09:19:39PM +0800, DDD wrote:
>> Peter Zijlstra wrote:
>>> On Fri, 2010-08-27 at 20:21 +0800, DDD wrote:
>>>
>>>>>> Maybe the root cause was from kgdb/hw_breakpoint_layer,
>>>>> Yeah, I think there's a bug in the hw_breakpoint stuff, does something
>>>>> like the below fix it?
>>>> Thanks for your patch, but I still could reproduce the problem with 
>>>> your patch.
>>> Frederic, any clue as to what makes hw breakpoints go funny and have
>>> last_period == 0?
>> Hi Peter,
>>
>> Thanks for you take care of it, I have got the root cause of it now.
>>
>> It is the kgdb using hw_breakpoint_layer's API problem, and I have a RFC  
>> patch for it.(maybe it is not correctly), I will contact with Jason to  
>> fix this problem.
>>
>> Thank you very much,
>> Dongdong
> 
> 
> Thanks!
> 
> We are waiting for your patch then.

Hello Frederic,

Sorry for delay, the patch have been accepted by Jason.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c1bb9a9c1911036549c5cdfb23f32d7d20ffdc5a

Dongdong
