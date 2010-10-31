Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0JaJBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 05:01:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50584 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0JaJBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 05:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QtwHB8ugeBy1rM8YdRAcfJhC+Tf9F4XT+ypwaT5iHJzhUcr9QNtkV/e8STfV/f7m+A
         IhM0SxiOkHJ9IpDxqdZx2NhqfYvbyiSKaKTfu0KmtQUUiLcxRR85mqcMetrZeHan4Y+f
         WCDzD8ITs0KiUYvrdVR2QHEmZU+glCVGoj7CQ=
MIME-Version: 1.0
In-Reply-To: <20101031084436.GA14001@elte.hu>
References: <AANLkTi=T2JXDT=jYRED8jMGiWdxwUt5vJ-RG=pfRv9dS@mail.gmail.com>
	<20101031084436.GA14001@elte.hu>
Date: Sun, 31 Oct 2010 15:01:43 +0600
Message-ID: <AANLkTim_Vc0c1WE8eiugqvYeJgDhODhKd4zDK12hA2Rt@mail.gmail.com>
Subject: Re: [PATCH] sched: Remove redundant #ifdef.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 2:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
>>  Remove redundant #ifdef to wrap struct cpupri. root_domain structure
>> is declared under #ifdef CONFIG_SMP, no need to use #ifdef again
>> inside the structure.
>>
>>
>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>> ---
>>
>> --- linus-36/kernel/sched.c   2010-10-21 02:30:22.000000000 +0600
>> +++ rakib-36/kernel/sched.c   2010-10-31 11:16:22.000000000 +0600
>> @@ -426,9 +426,7 @@ struct root_domain {
>>        */
>>       cpumask_var_t rto_mask;
>>       atomic_t rto_count;
>> -#ifdef CONFIG_SMP
>>       struct cpupri cpupri;
>> -#endif
>>  };
>
> The same patch was already sent by Christian Dietrich a few weeks ago, and it's
> upstream already:
>
>  ed2d372c0738: sched: Remove unnecessary #ifdef CONFIG_SMP
>

Ah... sorry for the noise :(. Should have checked it first. It seems
to me that I checked it..... but, certainly I missed it..


Thanks,

Rakib
> Thanks,
>
>        Ingo
>
