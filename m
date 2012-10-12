Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839Ab2JLQhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:37:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43324 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2JLQhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:37:16 -0400
Message-ID: <50784729.4030302@ti.com>
Date: Fri, 12 Oct 2012 11:36:57 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nishanth Menon <nm@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of kernel/bootloader
 boot time
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org> <20121012134542.GH12567@gmail.com> <20121012134813.GK21164@n2100.arm.linux.org.uk> <201210121353.16798.arnd@arndb.de> <20121012140149.GJ12567@gmail.com>
In-Reply-To: <20121012140149.GJ12567@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/12/2012 09:01 AM, Lee Jones wrote:
> On Fri, 12 Oct 2012, Arnd Bergmann wrote:
>
>> On Friday 12 October 2012, Russell King - ARM Linux wrote:
>>>> root@ME:/ cat /sys/kernel/debug/boottime/bootgraph
>>>> [    0.185254] calling  splash+0x0/0x0
>>>> [    2.984335] initcall splash+0x0/0x0 returned 0 after 2799 msecs.
>>>> [    2.984335] calling  autoboot_delay+0x0/0x0
>>>> [    4.089513] initcall autoboot_delay+0x0/0x0 returned 0 after 1105 msecs.
>>>> [    4.089513] calling  load_kernel+0x0/0x0
>>>> [    4.239174] initcall load_kernel+0x0/0x0 returned 0 after 149 msecs.
>>>> [    4.239174] calling  boot_kernel+0x0/0x0
>>>> [    4.276260] initcall boot_kernel+0x0/0x0 returned 0 after 37 msecs.
>>>> [    4.276260] calling  uncompress_ll_init+0x0/0x0
>>>> [    4.276260] initcall uncompress_ll_init+0x0/0x0 returned 0 after 0 msecs.
>>>> [    4.276260] Freeing init memory: 0K
>>> Umm, what happened to sysfs not becoming procfs v2?  I thought we had
>>> a fairly strict requirement for "one value per file and not nicely
>>> formatted" for sysfs?
>>>
>> I was thinking the same thing at first, but then I noticed it's actually
>> debugfs, which has no such rules.
> Right. :)
>
OK I don't see when boottime_activate is called.

Where would this call actually be made from?

I see the call to deactivate but no call to activate.

Dan
