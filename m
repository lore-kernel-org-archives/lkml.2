Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062Ab2EPBn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:43:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57401 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab2EPBn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:43:27 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-cf-4fb3063d6686
Message-ID: <4FB30663.3030202@kernel.org>
Date: Wed, 16 May 2012 10:44:03 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: konrad@darnok.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
References: <1336027242-372-4-git-send-email-minchan@kernel.org> <4FA28EFD.5070002@vflare.org> <4FA33E89.6080206@kernel.org> <alpine.LFD.2.02.1205071038090.2851@tux.localdomain> <4FA7C2BC.2090400@vflare.org> <4FA87837.3050208@kernel.org> <731b6638-8c8c-4381-a00f-4ecd5a0e91ae@default> <4FA9C127.5020908@kernel.org> <d8fb8c73-0fd4-47c6-a9bb-ba3573569d63@default> <4FAC5C87.3060504@kernel.org> <20120511190643.GB3785@phenom.dumpdata.com> <4FB06604.5060608@kernel.org> <CAPbh3ruaPQ+6s9t4KULYr2TdTUhUQNfQhFUt=C2jpvAvh+QTsQ@mail.gmail.com>
In-Reply-To: <CAPbh3ruaPQ+6s9t4KULYr2TdTUhUQNfQhFUt=C2jpvAvh+QTsQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 12:18 AM, Konrad Rzeszutek Wilk wrote:

>>>> I think it's not urgent than zs_handle mess.
>>>
>>> I am having a hard time parsing that. Are you saying that
>>> this is not as important as the zs_handle fixup? I think
>>> that is what you meant, but what to make sure.
>>
>>
>> Yes. I think zs_hande fixup is top priority for me than any other stuff I pointed out.
> 
> What else is should we put on the TODO?


Next I have a plan.

1. zs_handle zs_malloc(size_t size, gfp_t flags) - share a pool by many
subsystem(like kmalloc)
2. zs_handle zs_malloc_pool(struct zs_pool *pool, size_t size) - use own
pool(like kmem_cache_alloc)

And there is severe another item but I think it's not good time to
mention it because I don't have a big picture still yet.
Only thing I can speak is that it's would be related to zram or zcache.
I will compare which is better for me.

I will tell it if I am ready.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 
> 



-- 
Kind regards,
Minchan Kim
