Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab0JGDIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:08:41 -0400
Received: from xenotime.net ([72.52.115.56]:49271 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933021Ab0JGDIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:08:40 -0400
Message-ID: <39657.64.39.138.238.1286420910.squirrel@xenotime.net>
In-Reply-To: <22641647-5901-4C65-99D0-F9BF2064AD91@mac.com>
References: <B2C884FB-3933-4363-85C6-4F1206275B4C@mac.com>
    <55150.64.39.142.105.1286398399.squirrel@xenotime.net>
    <22641647-5901-4C65-99D0-F9BF2064AD91@mac.com>
Date: Wed, 6 Oct 2010 20:08:30 -0700 (PDT)
Subject: Re: Kernel config option missing: 'Compile the kernel with frame 
     pointers'
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Elvis Dowson" <elvis.dowson@mac.com>
Cc: "Randy Dunlap" <rdunlap@xenotime.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, October 6, 2010 2:00 pm, Elvis Dowson wrote:
> Hi Randy,
>
>
> On Oct 7, 2010, at 12:53 AM, Randy Dunlap wrote:
>
>>
>> It sounds like you don't have DEBUG_KERNEL symbol set.
>> You can't see the FRAME_POINTER kconfig symbol unless
>> DEBUG_KERNEL is set/enabled and you are on a qualifying
>> architecture:
>>
>>
>> config FRAME_POINTER bool "Compile the kernel with frame pointers"
>> depends on DEBUG_KERNEL && \ (CRIS || M68K || M68KNOMMU || FRV || UML ||
>> \
>> AVR32 || SUPERH || BLACKFIN || MN10300) || \
>> ARCH_WANT_FRAME_POINTERS
>> default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
>>
>>
>> The prompt for DEBUG_KERNEL is "Kernel debugging".
>> It is in the "Kernel hacking" menu.
>>
>
> I have CONFIG_DEBUG_KERNEL=y set. I'm compiling for the ARM architecture
> (TI OMAP 3503). So I guess it doesn't apply for ARM?

That's correct AFAICT.
ARM does not set (select) ARCH_WANT_FRAME_POINTERS.


> I want to debug the kernel using Eclipse IDE and kgdb.



-- 
~Randy

