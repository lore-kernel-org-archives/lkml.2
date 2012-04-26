Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab2DZBTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 21:19:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49934 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2DZBTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 21:19:40 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-c4-4f98a2a7771e
Message-ID: <4F98A2CC.4080104@kernel.org>
Date: Thu, 26 Apr 2012 10:20:12 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/6] zsmalloc: clean up and fix arch dependency
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <4F97F0F1.2000506@vflare.org>
In-Reply-To: <4F97F0F1.2000506@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On 04/25/2012 09:41 PM, Nitin Gupta wrote:

> Hi Minchan,
> 
> On 04/25/2012 02:23 AM, Minchan Kim wrote:
> 
>> This patchset has some clean up patches(1-5) and remove 
>> set_bit, flush_tlb for portability in [6/6].
>>
>> Minchan Kim (6):
>>   zsmalloc: use PageFlag macro instead of [set|test]_bit
>>   zsmalloc: remove unnecessary alignment
>>   zsmalloc: rename zspage_order with zspage_pages
>>   zsmalloc: add/fix function comment
>>   zsmalloc: remove unnecessary type casting
>>   zsmalloc: make zsmalloc portable
>>
>>  drivers/staging/zsmalloc/Kconfig         |    4 --
>>  drivers/staging/zsmalloc/zsmalloc-main.c |   73 +++++++++++++++++-------------
>>  drivers/staging/zsmalloc/zsmalloc_int.h  |    3 +-
>>  3 files changed, 43 insertions(+), 37 deletions(-)
>>
> 
> 
> Thanks for the fixes.
> 
> 
> Your description is missing testing notes (especially since patch [6/6]
> is not a cosmetic change). So, can you please add these either here in
> patch 0 or as part of patch 6/6 description?


Will do in later version.
Test is simply done in x86 and ARM qemu environment with zram so test coverage isn't good
but [1-6] is just trivial while [7] is severe. As I see Seth's reply, he could test it enough
and other architecture should work if it works in x86 because we used generic functions.

-- 
Kind regards,
Minchan Kim
