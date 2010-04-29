Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab0D3RwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:52:18 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:28233 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab0D3RwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:52:00 -0400
Message-ID: <4BD99A56.4070800@oracle.com>
Date: Thu, 29 Apr 2010 07:40:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 6/6] xconfig: Add support to show hidden options which
 have prompts
References: <4BD696C0.8050500@cn.fujitsu.com>	<4BD6970A.9020408@cn.fujitsu.com> <20100427134258.053b58cb.randy.dunlap@oracle.com> <4BD91FEC.6070903@cn.fujitsu.com>
In-Reply-To: <4BD91FEC.6070903@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4BD99A95.00C6:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/10 22:58, Li Zefan wrote:
> Randy Dunlap wrote:
>> On Tue, 27 Apr 2010 15:49:30 +0800 Li Zefan wrote:
>>
>>> This feature has been supported in menuconfig and gconfig, so
>>> here add it to xconfig.
>>
>> Looks/sounds reasonable, but it does hide some symbols that were previously displayed
>> when in "Show all options" mode.
>>
>> E.g., CONFIG_64BIT is not displayed at all with this patch applied
>> (except by the Search function).
>> Also, X86_32 is not displayed at all (when this patch is applied)
>> and it cannot be found or displayed by the Search function.
>>

I'm using a kernel source tree with your 12 patches applied.
Should that be OK?

I don't see any of the hidden (no prompt string) symbols from
arch/x86/Kconfig displayed.  Or maybe they have just moved, but I can't
locate them.

> 
> I don't see this issue, though I found a bug in this patch...
> Could you send me your .config (in private) ?

Done, but the issue is not config-specific.

>> IOW, Show all options mode is busted.  :(


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
