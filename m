Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab2J2Ief (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:34:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab2J2Ied (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:34:33 -0400
Message-ID: <508E4014.1070804@redhat.com>
Date: Mon, 29 Oct 2012 16:36:36 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sched, numa, mm: Add memcg support to do_huge_pmd_numa_page()
References: <20121025121617.617683848@chello.nl> <508A52E1.8020203@redhat.com> <1351242480.12171.48.camel@twins> <20121028175615.GC29827@cmpxchg.org> <508DEDA2.9030503@redhat.com> <20121029065044.GB14107@gmail.com> <20121029082403.GA1419@cmpxchg.org>
In-Reply-To: <20121029082403.GA1419@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 04:24 PM, Johannes Weiner wrote:
> Hello Ingo!
>
> On Mon, Oct 29, 2012 at 07:50:44AM +0100, Ingo Molnar wrote:
>> * Zhouping Liu <zliu@redhat.com> wrote:
>>
>>> Hi Johannes,
>>>
>>> Tested the below patch, and I'm sure it has fixed the above
>>> issue, thank you.
>> Thanks. Below is the folded up patch.
>>
>> 	Ingo
>>
>> ---------------------------->
>> Subject: sched, numa, mm: Add memcg support to do_huge_pmd_numa_page()
>> From: Johannes Weiner <hannes@cmpxchg.org>
>> Date: Thu Oct 25 12:49:51 CEST 2012
>>
>> Add memory control group support to hugepage migration.
>>
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> Tested-by: Zhouping Liu <zliu@redhat.com>
>> Link: http://lkml.kernel.org/n/tip-rDk9mgpoyhZlwh2xhlykvgnp@git.kernel.org
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> ---
>>   mm/huge_memory.c |   15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
> Did the mm/memcontrol.c part go missing?

I think so, as the issue is still existed with this patch

Thanks,
Zhouping
