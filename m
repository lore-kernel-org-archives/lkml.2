Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab2JTBrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:47:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16920 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933203Ab2JTBrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:47:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,618,1344182400"; 
   d="scan'208";a="6033513"
Message-ID: <5081F5B0.7000707@cn.fujitsu.com>
Date: Sat, 20 Oct 2012 08:52:00 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, bhelgaas@google.com,
        hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com,
        muneda.takahiro@jp.fujitsu.com
Subject: Re: [RESEND PATCH v2 1/2] update mem= option's spec according to
 its implementation
References: <1350641777-19605-1-git-send-email-wency@cn.fujitsu.com> <1350641777-19605-2-git-send-email-wency@cn.fujitsu.com> <CAHGf_=oDTLC8ebNgwCbT7NyxLre9c8ZokEKgjrORgzaHfZsTqQ@mail.gmail.com>
In-Reply-To: <CAHGf_=oDTLC8ebNgwCbT7NyxLre9c8ZokEKgjrORgzaHfZsTqQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/20 08:45:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/20 08:46:06,
	Serialize complete at 2012/10/20 08:46:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/20/2012 02:11 AM, KOSAKI Motohiro Wrote:
> On Fri, Oct 19, 2012 at 6:16 AM,  <wency@cn.fujitsu.com> wrote:
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> Current mem= implementation seems buggy because specification and
>> implementation doesn't match. Current mem= has been working
>> for many years and it's not buggy, it works as expected. So
>> we should update the specification.
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>
>> ---
>>  Documentation/kernel-parameters.txt |    7 ++++---
>>  1 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 9776f06..85b911a 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1481,9 +1481,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>         mem=nn[KMG]     [KNL,BOOT] Force usage of a specific amount of memory
>>                         Amount of memory to be used when the kernel is not able
>>                         to see the whole system memory or for test.
>> -                       [X86-32] Use together with memmap= to avoid physical
>> -                       address space collisions. Without memmap= PCI devices
>> -                       could be placed at addresses belonging to unused RAM.
>> +                       [X86-32] Work as limiting max address. Use together
>> +                       with memmap= to avoid physical address space collisions.
>> +                       Without memmap= PCI devices could be placed at addresses
>> +                       belonging to unused RAM.
> 
> If my remember is correct, x86-64 also specify maximum address.
> but my remember is not clear.
> 

Do you mean max_addr option? It is only for ia64 box.

Thanks
Wen Congyang
