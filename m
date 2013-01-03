Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3ACUNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 15:13:08 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:50658 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3ACUNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 15:13:05 -0500
MIME-Version: 1.0
In-Reply-To: <201301031601.00594.arnd@arndb.de>
References: <CAHTX3d+bwTNEhzB78mqoz6prk0nw0U_-1YFR3Tje_-uQLyTMBQ@mail.gmail.com>
	<26599.1357221783@warthog.procyon.org.uk>
	<CAHTX3d+C6_Vr-Q-UH8y9F_7=8GwBxzd8eECPN6tNBpxwr10=cQ@mail.gmail.com>
	<201301031601.00594.arnd@arndb.de>
Date: Thu, 3 Jan 2013 21:13:03 +0100
Message-ID: <CAHTX3dKra4vNsYPzQJbaU4jNmDT_rh-XViBD7yp3k7Ty0GsYog@mail.gmail.com>
Subject: Re: uapi __NR_syscalls for microblaze
From: Michal Simek <monstr@monstr.eu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/3 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 03 January 2013, Michal Simek wrote:
>> 2013/1/3 David Howells <dhowells@redhat.com>:
>> > Michal Simek <monstr@monstr.eu> wrote:
>> >
>> >> just want to check with you if __NR_syscalls is necessary for user space. I
>> >> see that powerpc and arm have this macro in asm not in uapi like Microblaze.
>> >> If is not needed by user space, I should move it to asm/unistd.h
>> >
>> > It isn't as far as I know...  I recommend putting your question on the
>> > linux-arch mailing list.
>>
>> I have add linux-arch to CC.
>
> Right, I'm pretty sure it's not needed, but it has traditionally been
> exported on a lot of platforms, so you can keep it in UAPI to be
> on the safe side.

Isn't it better to be consistent across all architectures?
If it is wrong to exported and there is no reason to use it in userspace
then all architecture should move it out of uapi.
If there is any reason then it is should be in uapi.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian
