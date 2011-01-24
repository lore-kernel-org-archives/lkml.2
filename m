Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1AXHig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 02:38:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52835 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1AXHie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 02:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k82kfvLvm9yUYNNf7sBqScEo+JqodQrvx5SmsFM1XXMgMbNc+y3e5y9YgoZnmNz3BG
         G+cDUkKV4KpK7nQcmYHt2ZEj/FrAZZRAF0aMqhv426wkWyioYK9wujqGNvq80Deil+n8
         z6JcQXsCwgKmdyFqQW5oZbNMlxGMClaiw9Hkk=
MIME-Version: 1.0
In-Reply-To: <4D396AAF.6080603@mvista.com>
References: <1295597961-7565-1-git-send-email-dengcheng.zhu@gmail.com>
	<1295597961-7565-4-git-send-email-dengcheng.zhu@gmail.com>
	<4D396AAF.6080603@mvista.com>
Date: Mon, 24 Jan 2011 15:38:34 +0800
Message-ID: <AANLkTin34=STRp+xstbvwD5W2scEfZj5Fjf0L7F=oo4j@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] MIPS/Perf-events: Fix event check in validate_event()
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, wuzhangjin@gmail.com, paulus@samba.org,
        mingo@elte.hu, acme@redhat.com, matt@console-pimps.org,
        ddaney@caviumnetworks.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. The patch set was resent.


Deng-Cheng

2011/1/21 Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 21-01-2011 11:19, Deng-Cheng Zhu wrote:
>
>> Ignore events that are in off/error state or belong to a different PMU.
>
>> This patch originates from the following commit for ARM by Will Deacon:
>
>> - 65b4711ff513767341aa1915c822de6ec0de65cb
>>     ARM: 6352/1: perf: fix event validation
>
>>     The validate_event function in the ARM perf events backend has the
>>     following problems:
>
>>     1.) Events that are disabled count towards the cost.
>>     2.) Events associated with other PMUs [for example, software events or
>>         breakpoints] do not count towards the cost, but do fail
>> validation,
>>         causing the group to fail.
>
>>     This patch changes validate_event so that it ignores events in the
>>     PERF_EVENT_STATE_OFF state or that are scheduled for other PMUs.
>
>> Changes:
>> v4 - v3:
>> o None
>> v3 - v2:
>> o Keep all mentioned commits in the form of number + title + original
>> summary + (MIPS specific info when needed).
>> v2 - v1:
>> o Corrected the return value of the event check in validate_event().
>
>   The patch changes should follow the --- tearline, not precede it.
>
>> Acked-by: Will Deacon<will.deacon@arm.com>
>> Acked-by: David Daney<ddaney@caviumnetworks.com>
>> Signed-off-by: Deng-Cheng Zhu<dengcheng.zhu@gmail.com>
>> ---
>
> WBR, Sergei
>
