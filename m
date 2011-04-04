Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1DDJbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:31:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48552 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1DDJbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:31:34 -0400
Message-ID: <4D998FF2.5050105@monstr.eu>
Date: Mon, 04 Apr 2011 11:31:30 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: Fix Kconfig unmet dependencies for Microblaze EHCI
References: <1301908812-8119-1-git-send-email-monstr@monstr.eu> <4D998EDD.1080404@ru.mvista.com>
In-Reply-To: <4D998EDD.1080404@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> On 04-04-2011 13:20, Michal Simek wrote:
> 
>> Disable USB_ARCH_HAS_EHCI in arch Kconfig and enable it in usb Kconfig
> 
>> Warning log:
>> warning: (LOCKDEP&&  FAULT_INJECTION_STACKTRACE_FILTER&&  
>> LATENCYTOP&&  FUNCTION_TRACER&&
>> KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies 
>> (DEBUG_KERNEL&&
>> (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) ||
>> ARCH_WANT_FRAME_POINTERS)
> 
>    Hm, what this has to do with USB_ARCH_HAS_EHCI?

aaah. c&p error. I was doing two patches and copy the same warning to both.

There should be:
warning: (MICROBLAZE) selects USB_ARCH_HAS_EHCI which has unmet direct 
dependencies (USB_SUPPORT)

Will replace it!

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
