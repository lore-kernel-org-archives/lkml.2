Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab2JaRLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:11:45 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50425 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab2JaRLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAAmzW4OboOMD+yrAim4-H_LBC439iYat=gwfxcn5M1gvcRyz=w@mail.gmail.com>
References: <1351451576-2611-1-git-send-email-js1304@gmail.com>
	<20121029021219.GK15767@bbox>
	<CAAmzW4OboOMD+yrAim4-H_LBC439iYat=gwfxcn5M1gvcRyz=w@mail.gmail.com>
Date: Thu, 1 Nov 2012 02:11:42 +0900
Message-ID: <CAAmzW4N+Pe_+MdLCjfVyw5Lih=vPeJj-+hLQuikp33OV_0SoiA@mail.gmail.com>
Subject: Re: [PATCH 0/5] minor clean-up and optimize highmem related code
From: JoonSoo Kim <js1304@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

2012/10/29 JoonSoo Kim <js1304@gmail.com>:
> Hi, Minchan.
>
> 2012/10/29 Minchan Kim <minchan@kernel.org>:
>> Hi Joonsoo,
>>
>> On Mon, Oct 29, 2012 at 04:12:51AM +0900, Joonsoo Kim wrote:
>>> This patchset clean-up and optimize highmem related code.
>>>
>>> [1] is just clean-up and doesn't introduce any functional change.
>>> [2-3] are for clean-up and optimization.
>>> These eliminate an useless lock opearation and list management.
>>> [4-5] is for optimization related to flush_all_zero_pkmaps().
>>>
>>> Joonsoo Kim (5):
>>>   mm, highmem: use PKMAP_NR() to calculate an index of pkmap
>>>   mm, highmem: remove useless pool_lock
>>>   mm, highmem: remove page_address_pool list
>>>   mm, highmem: makes flush_all_zero_pkmaps() return index of last
>>>     flushed entry
>>>   mm, highmem: get virtual address of the page using PKMAP_ADDR()
>>
>> This patchset looks awesome to me.
>> If you have a plan to respin, please CCed Peter.
>
> Thanks for review.
> I will wait more review and respin, the day after tomorrow.
> Version 2 will include fix about your comment.

Could you pick up second version of this patchset?

[3] is changed to leave one blank line.
[4] is changed in order to further optimize according to Minchan's comment.
It return first index of flushed entry, instead of last index.
Others doesn't changed.
