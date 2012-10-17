Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2JQMWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:22:40 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37784 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2JQMWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:22:39 -0400
Message-ID: <507EA308.9090106@gmail.com>
Date: Wed, 17 Oct 2012 20:22:32 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: wency@cn.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH v2 0/5] bugfix for memory hotplug
References: <1350475735-26136-1-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1350475735-26136-1-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 08:08 PM, wency@cn.fujitsu.com wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> Wen Congyang (5):
>    memory-hotplug: skip HWPoisoned page when offlining pages
>    memory-hotplug: update mce_bad_pages when removing the memory
>    memory-hotplug: auto offline page_cgroup when onlining memory block
>      failed
>    memory-hotplug: fix NR_FREE_PAGES mismatch
>    memory-hotplug: allocate zone's pcp before onlining pages

Oops, why you don't write changelog?

>
>   include/linux/page-isolation.h |   10 ++++++----
>   mm/memory-failure.c            |    2 +-
>   mm/memory_hotplug.c            |   14 ++++++++------
>   mm/page_alloc.c                |   37 ++++++++++++++++++++++++++++---------
>   mm/page_cgroup.c               |    3 +++
>   mm/page_isolation.c            |   27 ++++++++++++++++++++-------
>   mm/sparse.c                    |   21 +++++++++++++++++++++
>   7 files changed, 87 insertions(+), 27 deletions(-)
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

