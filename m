Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab2HMNYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:24:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62541 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2HMNYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:24:37 -0400
MIME-Version: 1.0
Date: Mon, 13 Aug 2012 21:24:36 +0800
Message-ID: <CAJd=RBCJL+oPRZMNNmtwSWH6CM1fiUNh=X+Leuk25Lyd3uKB5Q@mail.gmail.com>
Subject: Re: [PATCH] hugetlb: do not use vma_hugecache_offset for vma_prio_tree_foreach
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 9:09 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 13-08-12 20:10:41, Hillf Danton wrote:
>> On Sun, Aug 12, 2012 at 5:31 PM, Michal Hocko <mhocko@suse.cz> wrote:
>> > From d07b88a70ee1dbcc96502c48cde878931e7deb38 Mon Sep 17 00:00:00 2001
>> > From: Michal Hocko <mhocko@suse.cz>
>> > Date: Fri, 10 Aug 2012 15:03:07 +0200
>> > Subject: [PATCH] hugetlb: do not use vma_hugecache_offset for
>> >  vma_prio_tree_foreach
>> >
>> > 0c176d5 (mm: hugetlb: fix pgoff computation when unmapping page
>> > from vma) fixed pgoff calculation but it has replaced it by
>> > vma_hugecache_offset which is not approapriate for offsets used for
>> > vma_prio_tree_foreach because that one expects index in page units
>> > rather than in huge_page_shift.
>>
>>
>> What if another case of vma_prio_tree_foreach in try_to_unmap_file
>> is correct?
>
> That one is surely correct (linear_page_index converts the page offset).

But linear_page_index is not used in this patch, why?

> Anyway do you actually have any _real_ objection to the patch?

I will sign ack only after I see your answers to my questions.
Feel free to info me if you are unlikely to answer questions, Michal.
