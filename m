Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2APIWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:22:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51726 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2APIWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:22:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120116075639.GG15641@elte.hu>
References: <1326389222.9115.2.camel@localhost.localdomain>
	<20120116075639.GG15641@elte.hu>
Date: Mon, 16 Jan 2012 14:22:43 +0600
Message-ID: <CADZ9YHjxuqJ2YpEonqXjRsJZGsihy7ao_cA-NRwXoOM1KF3Tpw@mail.gmail.com>
Subject: Re: [PATCH] sched: Update scheduler stat documentation.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 1:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
>> /proc/schedstat's second field reflect to # of time context switch happened not # of times switched to the expired queue.
>>
>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>> ---
>>
>> diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
>> index 1cd5d51..7d8e12c 100644
>> --- a/Documentation/scheduler/sched-stats.txt
>> +++ b/Documentation/scheduler/sched-stats.txt
>> @@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
>>       1) # of times sched_yield() was called
>>
>>  Next three are schedule() statistics:
>> -     2) # of times we switched to the expired queue and reused it
>> +     2) # of times context switch happened. This field is not utilized these
>> +     days but kept for holding userspace tools integrity.
>
> if it's not used by anything but kept for the ABI then we should
> not put context switch number in there, but always keep it zero,
> right?
>
Yes, quite right. It is a bit confusing. Anyone might have think that
context switch numbers are 0. So, instead of saying "# of times
context switch happened", we can say, "This field has been kept for
ABI integrity". Right?

Thanks,
Rakib
