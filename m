Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab2I2CcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 22:32:10 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42948 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759399Ab2I2CcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 22:32:07 -0400
Message-ID: <50665D94.7040802@gmail.com>
Date: Sat, 29 Sep 2012 10:31:48 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: wency@cn.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 0/4] bugfix for memory hotplug
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 01:45 PM, wency@cn.fujitsu.com wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> Wen Congyang (2):
>    memory-hotplug: clear hwpoisoned flag when onlining pages
>    memory-hotplug: auto offline page_cgroup when onlining memory block
>      failed

Again, you should explain these two patches are the new version of 
memory-hotplug: hot-remove physical memory [20/21,21/21]

>
> Yasuaki Ishimatsu (2):
>    memory-hotplug: add memory_block_release
>    memory-hotplug: add node_device_release
>
>   drivers/base/memory.c |    9 ++++++++-
>   drivers/base/node.c   |   11 +++++++++++
>   mm/memory_hotplug.c   |    8 ++++++++
>   mm/page_cgroup.c      |    3 +++
>   4 files changed, 30 insertions(+), 1 deletions(-)
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

