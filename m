Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2LDKF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:05:59 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39219 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2LDKFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:05:54 -0500
Message-ID: <50BDCAFE.1070004@googlemail.com>
Date: Tue, 04 Dec 2012 10:05:50 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiang Liu <liuj97@gmail.com>, Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFT PATCH v2 4/5] mm: provide more accurate estimation of pages
 occupied by memmap
References: <20121120111942.c9596d3f.akpm@linux-foundation.org> <1353510586-6393-1-git-send-email-jiang.liu@huawei.com> <20121128155221.df369ce4.akpm@linux-foundation.org> <50B73E56.4050603@googlemail.com> <50BBB21D.3070005@googlemail.com> <20121203151715.8c536a7a.akpm@linux-foundation.org>
In-Reply-To: <20121203151715.8c536a7a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/03/12 23:17, Andrew Morton wrote:
> On Sun, 02 Dec 2012 19:55:09 +0000
> Chris Clayton <chris2553@googlemail.com> wrote:
>
>>
>>
>> On 11/29/12 10:52, Chris Clayton wrote:
>>> On 11/28/12 23:52, Andrew Morton wrote:
>>>> On Wed, 21 Nov 2012 23:09:46 +0800
>>>> Jiang Liu <liuj97@gmail.com> wrote:
>>>>
>>>>> Subject: Re: [RFT PATCH v2 4/5] mm: provide more accurate estimation
>>>>> of pages occupied by memmap
>>>>
>>>> How are people to test this?  "does it boot"?
>>>>
>>>
>>> I've been running kernels with Gerry's 5 patches applied for 11 days
>>> now. This is on a 64bit laptop but with a 32bit kernel + HIGHMEM. I
>>> joined the conversation because my laptop would not resume from suspend
>>> to disk - it either froze or rebooted. With the patches applied the
>>> laptop does successfully resume and has been stable.
>>>
>>> Since Monday, I have have been running a kernel with the patches (plus,
>>> from today, the patch you mailed yesterday) applied to 3.7rc7, without
>>> problems.
>>>
>>
>> I've been running 3.7-rc7 with the patches listed below for a week now
>> and it has been perfectly stable. In particular, my laptop will now
>> successfully resume from suspend to disk, which always failed without
>> the patches.
>>
>>   From Jiang Liu:
>> 1. [RFT PATCH v2 1/5] mm: introduce new field "managed_pages" to struct zone
>> 2. [RFT PATCH v1 2/5] mm: replace zone->present_pages with
>> zone->managed_pages if appreciated
>> 3. [RFT PATCH v1 3/5] mm: set zone->present_pages to number of existing
>> pages in the zone
>> 4. [RFT PATCH v2 4/5] mm: provide more accurate estimation of pages
>> occupied by memmap
>> 5. [RFT PATCH v1 5/5] mm: increase totalram_pages when free pages
>> allocated by bootmem allocator
>>
>>   From Andrew Morton:
>> 6. mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
>>
>> Tested-by: Chris Clayton <chris2553@googlemail.com>
>
> Thanks.
>
> I have only two of these five patches queued for 3.8:
> mm-introduce-new-field-managed_pages-to-struct-zone.patch and
> mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch.
> I don't recall what happened with the other three.
>

Gerry posted version 1 of the five patches on 18 November. Version 2 of 
the first and fourth patches were posted on 21 November.

BTW, the title of Andrew's patch that I applied is wrong above. It 
should be 
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.

Chris


