Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1AULQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 06:16:09 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33081 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1AULQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 06:16:07 -0500
Message-ID: <4D396AAF.6080603@mvista.com>
Date: Fri, 21 Jan 2011 14:14:55 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
CC: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, wuzhangjin@gmail.com, paulus@samba.org,
        mingo@elte.hu, acme@redhat.com, matt@console-pimps.org,
        ddaney@caviumnetworks.com
Subject: Re: [PATCH v4 3/5] MIPS/Perf-events: Fix event check in validate_event()
References: <1295597961-7565-1-git-send-email-dengcheng.zhu@gmail.com> <1295597961-7565-4-git-send-email-dengcheng.zhu@gmail.com>
In-Reply-To: <1295597961-7565-4-git-send-email-dengcheng.zhu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-01-2011 11:19, Deng-Cheng Zhu wrote:

> Ignore events that are in off/error state or belong to a different PMU.

> This patch originates from the following commit for ARM by Will Deacon:

> - 65b4711ff513767341aa1915c822de6ec0de65cb
>      ARM: 6352/1: perf: fix event validation

>      The validate_event function in the ARM perf events backend has the
>      following problems:

>      1.) Events that are disabled count towards the cost.
>      2.) Events associated with other PMUs [for example, software events or
>          breakpoints] do not count towards the cost, but do fail validation,
>          causing the group to fail.

>      This patch changes validate_event so that it ignores events in the
>      PERF_EVENT_STATE_OFF state or that are scheduled for other PMUs.

> Changes:
> v4 - v3:
> o None
> v3 - v2:
> o Keep all mentioned commits in the form of number + title + original
> summary + (MIPS specific info when needed).
> v2 - v1:
> o Corrected the return value of the event check in validate_event().

    The patch changes should follow the --- tearline, not precede it.

> Acked-by: Will Deacon<will.deacon@arm.com>
> Acked-by: David Daney<ddaney@caviumnetworks.com>
> Signed-off-by: Deng-Cheng Zhu<dengcheng.zhu@gmail.com>
> ---

WBR, Sergei
