Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab2JLS5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:57:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46375 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2JLS5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <507276A7.8070503@cn.fujitsu.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0D45.3050909@jp.fujitsu.com>
 <CAHGf_=pdVLEkGDvbMC7vjd0F8Y_YFdKX85YcLwR+gCQ8Tf2Mcw@mail.gmail.com> <507276A7.8070503@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 14:57:26 -0400
X-Google-Sender-Auth: vAN7DQm9m9PljKJ0GcSydLec5IM
Message-ID: <CAHGf_=qr=Qsa==X=pZifu=C1n=dwt7_Hz+AR+-oqoFT2LqRzqA@mail.gmail.com>
Subject: Re: [PATCH 2/4] acpi,memory-hotplug : rename remove_memory() to offline_memory()
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 2:45 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> At 10/05/2012 05:31 AM, KOSAKI Motohiro Wrote:
>> On Wed, Oct 3, 2012 at 6:02 AM, Yasuaki Ishimatsu
>> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>
>>> add_memory() hot adds a physical memory. But remove_memory does not
>>> hot remove a phsical memory. It only offlines memory. The name
>>> confuse us.
>>>
>>> So the patch renames remove_memory() to offline_memory(). We will
>>> use rename_memory() for hot removing memory.
>>>
>>> CC: David Rientjes <rientjes@google.com>
>>> CC: Jiang Liu <liuj97@gmail.com>
>>> CC: Len Brown <len.brown@intel.com>
>>> CC: Christoph Lameter <cl@linux.com>
>>> Cc: Minchan Kim <minchan.kim@gmail.com>
>>> CC: Andrew Morton <akpm@linux-foundation.org>
>>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>> ---
>>>  drivers/acpi/acpi_memhotplug.c |    2 +-
>>>  include/linux/memory_hotplug.h |    2 +-
>>>  mm/memory_hotplug.c            |    6 +++---
>>>  3 files changed, 5 insertions(+), 5 deletions(-)
>>
>> Probably, the better way is to just remove remove_memory() and use
>> offline_pages().
>
> we don't notify the userspace that the memory is offlined in offline_pages().
> We reimplement offline_memory(), but ishimatsu doesn't include that patch to
> this series.

Quote from Documentation/SubmittingPatch

> 3) Separate your changes.
> Separate _logical changes_ into a single patch file.

Please send us _logical_ meaningful patch set.
