Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3AGWgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:36:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3AGWgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:36:05 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=3csswWSbI5MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=60oAcdMYphAA:10 a=D19gQVrFAAAA:8 a=iox4zFpeAAAA:8 a=xXf59UwAZ8NuLoa7OVIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=n9GBPR9yFnkA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357598164.5190.12.camel@gandalf.local.home>
Subject: Re: [PATCH] staging/sb105x: remove asm/segment.h dependency
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Mon, 07 Jan 2013 17:36:04 -0500
In-Reply-To: <50EB4A3B.1020307@suse.com>
References: <50EB4A3B.1020307@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is obsoleted by:

https://lkml.org/lkml/2012/12/13/710

Which I just got the automated reply, and it's in Greg's staging tree
now.

When I get time, I do want to try to get this driver (and device)
working on my ppc64 box.

Thanks,

-- Steve


On Mon, 2013-01-07 at 17:20 -0500, Jeff Mahoney wrote:
> sb105x doesn't seem to actually need <asm/segment.h> (builds on x86
> without it) and ppc/ppc64 doesn't provide it so it fails to build there.
> 
> This patch removes the dependency. Unfortunately, it now fails to build
> because STD_COM_FLAGS isn't defined on most architectures. I'm not familiar
> enough with the tty/serial system to patch that aspect of it.
> 
> CC: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
> 
>  drivers/staging/sb105x/sb_pci_mp.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- a/drivers/staging/sb105x/sb_pci_mp.h
> +++ b/drivers/staging/sb105x/sb_pci_mp.h
> @@ -19,7 +19,6 @@
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
>  #include <asm/irq.h>
> -#include <asm/segment.h>
>  #include <asm/serial.h>
>  #include <linux/interrupt.h>
>  
> 
> 


