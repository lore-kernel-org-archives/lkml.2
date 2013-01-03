Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3ACOME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:12:04 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54828 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3ACOMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:12:00 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2013 09:12:00 EST
MIME-Version: 1.0
In-Reply-To: <26599.1357221783@warthog.procyon.org.uk>
References: <CAHTX3d+bwTNEhzB78mqoz6prk0nw0U_-1YFR3Tje_-uQLyTMBQ@mail.gmail.com>
	<26599.1357221783@warthog.procyon.org.uk>
Date: Thu, 3 Jan 2013 15:06:59 +0100
Message-ID: <CAHTX3d+C6_Vr-Q-UH8y9F_7=8GwBxzd8eECPN6tNBpxwr10=cQ@mail.gmail.com>
Subject: Re: uapi __NR_syscalls for microblaze
From: Michal Simek <monstr@monstr.eu>
To: David Howells <dhowells@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/3 David Howells <dhowells@redhat.com>:
> Michal Simek <monstr@monstr.eu> wrote:
>
>> just want to check with you if __NR_syscalls is necessary for user space. I
>> see that powerpc and arm have this macro in asm not in uapi like Microblaze.
>> If is not needed by user space, I should move it to asm/unistd.h
>
> It isn't as far as I know...  I recommend putting your question on the
> linux-arch mailing list.

I have add linux-arch to CC.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian
