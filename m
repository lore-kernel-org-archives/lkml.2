Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1C1Hxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:53:49 -0400
Received: from relay.parallels.com ([195.214.232.42]:53880 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1C1Hxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:53:48 -0400
Message-ID: <4D903E74.4070303@parallels.com>
Date: Mon, 28 Mar 2011 11:53:24 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101214 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] initcall: add config option for compiling initcall_debug
References: <20110327115506.14008.17733.stgit@localhost6> <20110327104332.6703de4c.randy.dunlap@oracle.com>
In-Reply-To: <20110327104332.6703de4c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 27 Mar 2011 15:55:06 +0400 Konstantin Khlebnikov wrote:
>
>> Add bool config option CONFIG_INITCALL_DEBUG for compiling initcalls debuging,
>> make it on by default to keep current behaviour.
>
> Typo fixes only:

Ok, thanks.

>
>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> ---
>>   Documentation/kernel-parameters.txt |    2 +-
>>   include/linux/init.h                |    4 ++++
>>   init/main.c                         |    2 ++
>>   kernel/async.c                      |    4 +---
>>   lib/Kconfig.debug                   |    7 +++++++
>>   5 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index c357a31..ea3843a 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -970,7 +970,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>
>>   	initcall_debug	[KNL] Trace initcalls as they are executed.  Useful
>>   			for working out where the kernel is dying during
>> -			startup.
>> +			startup. This depend on CONFIG_INITCALL_DEBUG option.
>
> 			depends on the CONFIG_INITCALL_DEBUG option.
>
>>
>>   	initrd=		[BOOT] Specify the location of the initial ramdisk
>
>
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index df9234c..ebc1357 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -807,6 +807,13 @@ config DEBUG_CREDENTIALS
>>
>>   	  If unsure, say N.
>>
>> +config INITCALL_DEBUG
>> +	bool "Debug kernel initcalls"
>> +	default y
>> +	help
>> +	  This build option allow you trace initcalls after
>
> 	allows you to trace initcalls by
>
>> +	  adding "initcall_debug" to kernel command line.
>
> 	to the kernel command line.
>
>> +
>>   #
>>   # Select this config option from the architecture Kconfig, if it
>>   # it is preferred to always offer frame pointers as a config
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

