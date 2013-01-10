Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3AJC0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:26:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2588 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab3AJC0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:26:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,442,1355068800"; 
   d="scan'208";a="6554614"
Message-ID: <50EE26B4.40204@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 10:25:56 +0800
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
Subject: Re: [PATCH v6 05/15] memory-hotplug: introduce new function arch_remove_memory()
 for removing page table depends on architecture
References: <1357723959-5416-1-git-send-email-tangchen@cn.fujitsu.com> <1357723959-5416-6-git-send-email-tangchen@cn.fujitsu.com> <20130109145031.210505d0.akpm@linux-foundation.org>
In-Reply-To: <20130109145031.210505d0.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 10:26:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 10:26:08,
	Serialize complete at 2013/01/10 10:26:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 01/10/2013 06:50 AM, Andrew Morton wrote:
> On Wed, 9 Jan 2013 17:32:29 +0800
> Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>
>> For removing memory, we need to remove page table. But it depends
>> on architecture. So the patch introduce arch_remove_memory() for
>> removing page table. Now it only calls __remove_pages().
>>
>> Note: __remove_pages() for some archtecuture is not implemented
>>        (I don't know how to implement it for s390).
>
> Can this break the build for s390?

No, I don't think so. The arch_remove_memory() in s390 will only
return -EBUSY.

Thanks. :)

>
>
>

