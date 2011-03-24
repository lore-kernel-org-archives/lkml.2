Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab1CXNVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:21:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1CXNVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:21:03 -0400
Message-ID: <4D8B4514.9050904@redhat.com>
Date: Thu, 24 Mar 2011 09:20:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: akpm@linux-foundation.org, nai.xia@gmail.com, aarcange@redhat.com,
        chrisw@sous-sol.org, hugh.dickins@tiscali.co.uk,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: + ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
 added to -mm tree
References: <201103012341.p21Nf64e006469@imap1.linux-foundation.org> <20110324125316.GA2310@cmpxchg.org>
In-Reply-To: <20110324125316.GA2310@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 08:53 AM, Johannes Weiner wrote:
> On Tue, Mar 01, 2011 at 03:41:06PM -0800, akpm@linux-foundation.org wrote:
>> diff -puN include/linux/mmzone.h~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages include/linux/mmzone.h
>> --- a/include/linux/mmzone.h~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages
>> +++ a/include/linux/mmzone.h
>> @@ -115,6 +115,9 @@ enum zone_stat_item {
>>   	NUMA_OTHER,		/* allocation from other node */
>>   #endif
>>   	NR_ANON_TRANSPARENT_HUGEPAGES,
>> +#ifdef CONFIG_KSM
>> +	NR_KSM_PAGES_SHARING,
>> +#endif
>>   	NR_VM_ZONE_STAT_ITEMS };
>
> This adds a zone stat item without a corresponding entry in
> vm_stat_text.  As a result, all vm event entries in /proc/vmstat show
> the value of the respective previous counter.
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
