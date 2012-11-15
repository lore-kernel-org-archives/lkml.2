Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993006Ab2KOJ7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:59:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52251 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2KOJ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:59:46 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50A4BCF9.7080401@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 18:59:21 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PART4 Patch 0/2] memory-hotplug: allow online/offline memory
 to result movable node
References: <1351671334-10243-1-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1351671334-10243-1-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/31 17:15, Wen Congyang wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> This patch is part4 of the following patchset:
>      https://lkml.org/lkml/2012/10/29/319
> 
> Part1 is here:
>      https://lkml.org/lkml/2012/10/31/30
> 
> Part2 is here:
>      http://marc.info/?l=linux-kernel&m=135166705909544&w=2
> 
> Part3 is here:
>      http://marc.info/?l=linux-kernel&m=135167050510527&w=2
> 
> You must apply part1-3 before applying this patchset.
> 
> we need a node which only contains movable memory. This feature is very
> important for node hotplug. If a node has normal/highmem, the memory
> may be used by the kernel and can't be offlined. If the node only contains
> movable memory, we can offline the memory and the node.
> 
> 
> Lai Jiangshan (2):
>    numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
>    memory_hotplug: allow online/offline memory to result movable node
> 
>   drivers/base/node.c      |  6 ++++++
>   include/linux/nodemask.h |  4 ++++
>   mm/Kconfig               |  8 ++++++++
>   mm/memory_hotplug.c      | 16 ++++++++++++++++
>   mm/page_alloc.c          |  3 +++
>   5 files changed, 37 insertions(+)
> 

Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

