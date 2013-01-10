Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab3AJCTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:19:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab3AJCT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:19:29 -0500
X-IronPort-AV: E=Sophos;i="4.84,441,1355068800"; 
   d="scan'208";a="6554539"
Message-ID: <50EE2500.2040903@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 10:18:40 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rientjes@google.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        wujianguo@huawei.com, wency@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v6 00/15] memory-hotplug: hot-remove physical memory
References: <1357723959-5416-1-git-send-email-tangchen@cn.fujitsu.com> <20130109153324.bbd019b3.akpm@linux-foundation.org>
In-Reply-To: <20130109153324.bbd019b3.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 10:18:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 10:18:53,
	Serialize complete at 2013/01/10 10:18:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 01/10/2013 07:33 AM, Andrew Morton wrote:
> On Wed, 9 Jan 2013 17:32:24 +0800
> Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>
>> This patch-set aims to implement physical memory hot-removing.
>
> As you were on th patch delivery path, all of these patches should have
> your Signed-off-by:.  But some were missing it.  I fixed this in my
> copy of the patches.

Thank you very much for the help. Next time I'll add it myself.

>
>
> I suspect this patchset adds a significant amount of code which will
> not be used if CONFIG_MEMORY_HOTPLUG=n.  "[PATCH v6 06/15]
> memory-hotplug: implement register_page_bootmem_info_section of
> sparse-vmemmap", for example.  This is not a good thing, so please go
> through the patchset (in fact, go through all the memhotplug code) and
> let's see if we can reduce the bloat for CONFIG_MEMORY_HOTPLUG=n
> kernels.
>
> This needn't be done immediately - it would be OK by me if you were to
> defer this exercise until all the new memhotplug code is largely in
> place.  But please, let's do it.

OK, I'll do have a check on it when the page_cgroup problem is solved.

Thanks. :)

>
>
>

