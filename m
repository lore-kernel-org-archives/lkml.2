Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1ATRvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:51:18 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15115 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1ATRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:51:17 -0500
Message-ID: <4D387612.5080502@caviumnetworks.com>
Date: Thu, 20 Jan 2011 09:51:14 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Dezhong Diao <dediao@cisco.com>, Gabor Juhos <juhosg@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/6] MIPS: perf: Reorganize contents of perf support files.
References: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>	<1294367707-2593-5-git-send-email-ddaney@caviumnetworks.com> <AANLkTi=5+QxOipaTycLBuLUHr7iOGCe0nfG9mQsKADoj@mail.gmail.com>
In-Reply-To: <AANLkTi=5+QxOipaTycLBuLUHr7iOGCe0nfG9mQsKADoj@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2011 17:51:14.0795 (UTC) FILETIME=[A1D163B0:01CBB8CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 02:01 AM, Deng-Cheng Zhu wrote:
> 2011/1/7 David Daney<ddaney@caviumnetworks.com>:
>> @@ -1034,5 +1560,3 @@ init_hw_perf_events(void)
>>         return 0;
>>   }
>>   arch_initcall(init_hw_perf_events);
>> -
>> -#endif /* defined(CONFIG_CPU_MIPS32)... */
>
> arch_initcall should be now early_initcall.
>

Yes, with my current patch set, it is as you indicate.

I will try to send a new patch set later today.

David Daney
