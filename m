Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0ECSDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:03:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48944 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab0ECSDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:03:02 -0400
Message-ID: <4BDF0F91.6080608@oracle.com>
Date: Mon, 03 May 2010 11:01:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 6/6] xconfig: Add support to show hidden options which
 have prompts
References: <4BD696C0.8050500@cn.fujitsu.com>	<4BD6970A.9020408@cn.fujitsu.com> <20100427134258.053b58cb.randy.dunlap@oracle.com> <4BD91FEC.6070903@cn.fujitsu.com> <4BD99A56.4070800@oracle.com> <4BDA35AD.6000407@cn.fujitsu.com>
In-Reply-To: <4BDA35AD.6000407@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090205.4BDF0FAB.009A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/10 18:43, Li Zefan wrote:
> Randy Dunlap wrote:
>> On 04/28/10 22:58, Li Zefan wrote:
>>> Randy Dunlap wrote:
>>>> On Tue, 27 Apr 2010 15:49:30 +0800 Li Zefan wrote:
>>>>
>>>>> This feature has been supported in menuconfig and gconfig, so
>>>>> here add it to xconfig.
>>>> Looks/sounds reasonable, but it does hide some symbols that were previously displayed
>>>> when in "Show all options" mode.
>>>>
>>>> E.g., CONFIG_64BIT is not displayed at all with this patch applied
>>>> (except by the Search function).
>>>> Also, X86_32 is not displayed at all (when this patch is applied)
>>>> and it cannot be found or displayed by the Search function.
>>>>
>>
>> I'm using a kernel source tree with your 12 patches applied.
>> Should that be OK?
>>
> 
> Should be Ok. I'm using -tip tree with those 12 patches applied.
> So which source tree are you using?

linux-2.6.34-rc4 + your 12 patches.

> If we use the same tree, the same arch (x86_32), and the same .config,
> we shuold see the same result.

I'm using ARCH=x86_64

>> I don't see any of the hidden (no prompt string) symbols from
>> arch/x86/Kconfig displayed.  Or maybe they have just moved, but I can't
>> locate them.
>>
> 
> So we can't see "64BIT" in "Show prompt options" mode either ?

It shows up in the Search box but not in any regular menu AFAICT.

> (btw, I'll be on vacation, and probably won't be responsive util 5/6...)

OK, no problem.


thanks.
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
