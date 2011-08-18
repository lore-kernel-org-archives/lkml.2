Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1HRC0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:26:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34604 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1HRC0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <4E4C75F0.10701@cn.fujitsu.com>
References: <1313633289-11410-1-git-send-email-leemgs1@gmail.com>
	<4E4C75F0.10701@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 11:26:34 +0900
Message-ID: <CABiHV1R9Bnwbt0eW_05O5pC2_QObhwDRr8xGa6iwY3tCz7wVig@mail.gmail.com>
Subject: Re: [PATCH] file info modification to maintain perf
From: Geunsik Lim <leemgs1@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jiri Kosina <trivial@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Joe Perches <joe@perches.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 11:16 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Geunsik Lim wrote:
>> From: Geunsik Lim <geunsik.lim@samsung.com>
>>
>> Actually, perf related c sources depends on architecture core.
>> So,'./kernel/perf_event.c'file still not exist from the latest
>> linux version.
>>
>
> kernel/perf_event.c has been splitted and moved to kernel/events/*
Yes. You are right.
So I submitted this patch for update.

Thanks your advice.
I will append  kernel/events/* content  that means performance events
core code again.

>
>> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>  MAINTAINERS |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1d445f5..7ae72d49 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -4971,7 +4971,6 @@ M:      Paul Mackerras <paulus@samba.org>
>>  M:   Ingo Molnar <mingo@elte.hu>
>>  M:   Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>>  S:   Supported
>> -F:   kernel/perf_event*.c
>>  F:   include/linux/perf_event.h
>>  F:   arch/*/kernel/perf_event*.c
>>  F:   arch/*/kernel/*/perf_event*.c
>



-- 
Regards,
Geunsik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
