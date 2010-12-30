Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab0L3W5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 17:57:43 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14324 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0L3W5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 17:57:42 -0500
Message-ID: <4D1D0E62.5010609@caviumnetworks.com>
Date: Thu, 30 Dec 2010 14:57:38 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>, ralf@linux-mips.org
CC: a.p.zijlstra@chello.nl, fweisbec@gmail.com, will.deacon@arm.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        matt@console-pimps.org, sshtylyov@mvista.com
Subject: Re: [PATCH v3 0/5] MIPS/Perf-events: Sync with mainline upper layer
 (v3)
References: <1291022351-13152-1-git-send-email-dengcheng.zhu@gmail.com>
In-Reply-To: <1291022351-13152-1-git-send-email-dengcheng.zhu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Dec 2010 22:57:38.0866 (UTC) FILETIME=[F4E74120:01CBA874]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 01:19 AM, Deng-Cheng Zhu wrote:
> Current MIPS Perf-events uses older interfaces to the generic layer. So it
> will not work. This patch set fixes this issue (reported by Wu Zhangjin) by
> adding MIPS counterparts for a list of previous commits that went to
> mainline earlier.
>
> Changes:
> v3 - v2:
> o Keep all mentioned commits in the form of number + title + original
> summary + (MIPS specific info when needed).
> v2 - v1:
> o Corrected the return value of the event check in validate_event().
>
> Deng-Cheng Zhu (5):
>    MIPS/Perf-events: Work with irq_work
>    MIPS/Perf-events: Work with the new PMU interface
>    MIPS/Perf-events: Fix event check in validate_event()
>    MIPS/Perf-events: Work with the new callchain interface
>    MIPS/Perf-events: Use unsigned delta for right shift in event update
>
>   arch/mips/Kconfig                    |    1 +
>   arch/mips/include/asm/perf_event.h   |   12 +-
>   arch/mips/kernel/perf_event.c        |  345 ++++++++++++++++------------------
>   arch/mips/kernel/perf_event_mipsxx.c |    4 +-
>   4 files changed, 171 insertions(+), 191 deletions(-)
>

Entire set:

Acked-by: David Daney <ddaney@caviumnetworks.com>

I am basing my modifications for Octeon perf counters on this set.

David Daney
