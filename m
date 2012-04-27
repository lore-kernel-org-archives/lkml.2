Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2D0I0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:26:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40783 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2D0IZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:25:58 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXgUb4UzXfJOTgFD9T=nSFOu7WGvPEmSpFBu-nSThUZaPg@mail.gmail.com>
References: <CANQmPXh-cu9tOJfceNZRHCBKFwR1-D5gQJOdMsnjty_LeLAADw@mail.gmail.com>
	<CAJd=RBD4KaXtqiShWtDk3AWJb+ZQFEYEw41dZna=7am31jWVCw@mail.gmail.com>
	<CANQmPXjoLvYe+X=TripkZi2s8JDG5pRYRYWS7FAMK_oixcHL7g@mail.gmail.com>
	<CAJd=RBDp1PQ8+YUBW363e0OhS+TGnZ7jyux-gRCRYmx_CXjADQ@mail.gmail.com>
	<CANQmPXgUb4UzXfJOTgFD9T=nSFOu7WGvPEmSpFBu-nSThUZaPg@mail.gmail.com>
Date: Fri, 27 Apr 2012 16:25:58 +0800
Message-ID: <CANQmPXhQYnCn7b2fL_eBRf+QNPb4p2HLUZgcDs3VVeB51=6xpg@mail.gmail.com>
Subject: Re: [PATCH] RIFS cpu scheduler
From: mou Chen <hi3766691@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 4:10 PM, mou Chen <hi3766691@gmail.com> wrote:
> On Tue, Apr 24, 2012 at 7:57 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> On Mon, Apr 23, 2012 at 9:38 PM, mou Chen <hi3766691@gmail.com> wrote:
>>>
>>> The SMP code is the same.The algorithum is different. :-)
>>>
>> Then would you please share the output of?
>>
>>              diff -pu bfs-version rifs-version
>
> No any string "bfs-version" was found.
>
> Also I have just finish rewriting the scheduler's code in a more
> readable way.For example changing goto need_resched to loop, dividing
> workqueue sleep checking in a individual function.
>
> I haven't post the newest code yet. :-(
>
>                                                             Chen

Also the thing I want to say is, do not try to increase the clock
frequency.It is a stubid way really and still still many guys think
that it is the way to decrease the latency. :-( Everyone knows that
the latency is measuring that the time needed for waking up a process.

For example, an interactive task sleeps 100ms, then when it continues
running, the process hasn't run for 120 ms on SCHED_A.The process
hasn't run for 101ms when it is running on a SHCED_B kernel and we
would say SCHED_B is more interactive than SCHED_A. So there is not
too much relation between latency and clock frequency.

RIFS is not using any fomula and the algorithum RIFS use is simple and
it works very well with make -j64.There is no lagging with firefox.
:-)

                                                                Chen
