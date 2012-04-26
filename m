Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2DZBqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 21:46:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46972 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2DZBqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 21:46:23 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-c9-4f98a8e780ad
Message-ID: <4F98A90C.9020705@kernel.org>
Date: Thu, 26 Apr 2012 10:46:52 +0900
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
Subject: Re: [PATCH 3/6] zsmalloc: rename zspage_order with zspage_pages
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-4-git-send-email-minchan@kernel.org> <4F97F634.1010400@vflare.org>
In-Reply-To: <4F97F634.1010400@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 10:03 PM, Nitin Gupta wrote:

> On 04/25/2012 02:23 AM, Minchan Kim wrote:
> 
>> zspage_order defines how many pages are needed to make a zspage.
>> So _order_ is rather awkward naming. It already deceive Jonathan
>> - http://lwn.net/Articles/477067/
>> " For each size, the code calculates an optimum number of pages (up to 16)"
>>
>> Let's change from _order_ to _pages_.
>>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  drivers/staging/zsmalloc/zsmalloc-main.c |   14 +++++++-------
>>  drivers/staging/zsmalloc/zsmalloc_int.h  |    2 +-
>>  2 files changed, 8 insertions(+), 8 deletions(-)
>>
> 
> 
> Recently, Seth changed max_zspage_order to ZS_MAX_PAGES_PER_ZSPAGE for
> the same reason. I think it would be better to rename the function in a
> similary way to have some consistency. So, we could use:
> 
> 1) get_pages_per_zspage() instead of get_zspage_pages()
> 2) class->pages_per_zspage instead of class->zspage_pages
> 


No problem. Will do.

-- 
Kind regards,
Minchan Kim
