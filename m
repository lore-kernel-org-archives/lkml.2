Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2IJBrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:47:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51247 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2IJBrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:47:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <504D467D.2080201@jp.fujitsu.com>
Date: Mon, 10 Sep 2012 10:46:37 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: <wency@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <x86@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <cmetcalf@tilera.com>,
        <sparclinux@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <benh@kernel.crashing.org>,
        <paulus@samba.org>, <cl@linux.com>, <minchan.kim@gmail.com>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC v8 PATCH 00/20] memory-hotplug: hot-remove physical memory
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com> <20120831134956.fec0f681.akpm@linux-foundation.org>
In-Reply-To: <20120831134956.fec0f681.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wen,

2012/09/01 5:49, Andrew Morton wrote:
> On Tue, 28 Aug 2012 18:00:07 +0800
> wency@cn.fujitsu.com wrote:
>
>> This patch series aims to support physical memory hot-remove.
>
> Have you had much review and testing feedback yet?
>
>> The patches can free/remove the following things:
>>
>>    - acpi_memory_info                          : [RFC PATCH 4/19]
>>    - /sys/firmware/memmap/X/{end, start, type} : [RFC PATCH 8/19]
>>    - iomem_resource                            : [RFC PATCH 9/19]
>>    - mem_section and related sysfs files       : [RFC PATCH 10-11, 13-16/19]
>>    - page table of removed memory              : [RFC PATCH 12/19]
>>    - node and related sysfs files              : [RFC PATCH 18-19/19]
>>
>> If you find lack of function for physical memory hot-remove, please let me
>> know.
>

> I doubt if many people have hardware which permits physical memory
> removal?  How would you suggest that people with regular hardware can
> test these chagnes?

How do you test the patch? As Andrew says, for hot-removing memory,
we need a particular hardware. I think so too. So many people may want
to know how to test the patch.
If we apply following patch to kvm guest, can we hot-remove memory on
kvm guest?

http://lists.gnu.org/archive/html/qemu-devel/2012-07/msg01389.html

Thanks,
Yasuaki Ishimatsu

>
>> Known problems:
>> 1. memory can't be offlined when CONFIG_MEMCG is selected.
>
> That's quite a problem!  Do you have a description of why this is the
> case, and a plan for fixing it?
>


