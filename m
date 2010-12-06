Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab0LFQOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:14:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60977 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0LFQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:14:44 -0500
Date: Mon, 6 Dec 2010 08:14:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 6 (pch_uart)
Message-Id: <20101206081422.0608c50d.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTi=iCZ=XQk3zXwK-BPnK4=9SU5W-arf+rom9dx8V@mail.gmail.com>
References: <20101206140055.34289498.sfr@canb.auug.org.au>
	<AANLkTi=iCZ=XQk3zXwK-BPnK4=9SU5W-arf+rom9dx8V@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010 16:09:33 +0100 Zimny Lech wrote:

> Ave,
> 
> 2010/12/6 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > [The mirroring on kernel.org is currently being slow, so this release may
> > not be available yet.]
> >
> > Changes since 20101203:
> >
> 
> Nothing new here, only known issues
> 
> Kernel: arch/x86/boot/bzImage is ready  (#5)
>   Building modules, stage 2.
>   MODPOST 314 modules
> ERROR: "dma_release_channel" [drivers/serial/pch_uart.ko] undefined!
> ERROR: "__dma_request_channel" [drivers/serial/pch_uart.ko] undefined!
> WARNING: modpost: Found 4 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make: *** [sub-make] Error 2

Greg, are you going to merge the patch that I posted for this one?



> WARNING: modpost: Found 9 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `pch_uart_startup':
> pch_uart.c:(.text+0x102efc): undefined reference to `__dma_request_channel'
> pch_uart.c:(.text+0x102f46): undefined reference to `__dma_request_channel'
> pch_uart.c:(.text+0x103037): undefined reference to `dma_release_channel'
> drivers/built-in.o: In function `pch_uart_shutdown':
> pch_uart.c:(.text+0x103135): undefined reference to `dma_release_channel'
> pch_uart.c:(.text+0x103151): undefined reference to `dma_release_channel'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2
> 

same patch as above.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
