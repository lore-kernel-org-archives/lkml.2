Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab0DGEF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 00:05:26 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:61995 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0DGEFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 00:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SLPXweTO8UWpeMGbMGU50TugRaf5PoG5itfyoXB6fqVCrwYK7mnSprKisf3jfY4gX5
         M2v9iMfgRtcShRve+eTEdO3OU5ZvHpoSrRBaaPUCJHSCQYflBwhbJ5T8RB7gVAPCAO8K
         m0VmRhgJrcbZfuFBqEtubGhgtR7DUbdJ5Ocbk=
MIME-Version: 1.0
In-Reply-To: <p2r9c2470ce1004062104ra6b9c662uf303fb1b9e82cd6@mail.gmail.com>
References: <p2r9c2470ce1004062104ra6b9c662uf303fb1b9e82cd6@mail.gmail.com>
Date: Wed, 7 Apr 2010 06:05:18 +0200
Message-ID: <x2t9c2470ce1004062105g83a050d0gc2269e4a8af7ae05@mail.gmail.com>
Subject: Re: [PATCH] build error drivers/staging/dt3155/dt3155_drv.c
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 7 kwietnia 2010 06:04 u¿ytkownik Jan III Sobieski
<jan3sobi3ski@gmail.com> napisa³:
> Hi,
>
>  CC      drivers/staging/dt3155/dt3155_drv.o
> drivers/staging/dt3155/dt3155_drv.c: In function 'init_module':
> drivers/staging/dt3155/dt3155_drv.c:1047: error: implicit declaration
> of function 'request_irq'
> drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_SHARED'
> undeclared (first use in this function)
> drivers/staging/dt3155/dt3155_drv.c:1048: error: (Each undeclared
> identifier is reported only once
> drivers/staging/dt3155/dt3155_drv.c:1048: error: for each function it
> appears in.)
> drivers/staging/dt3155/dt3155_drv.c:1048: error: 'IRQF_DISABLED'
> undeclared (first use in this function)
> drivers/staging/dt3155/dt3155_drv.c: In function 'cleanup_module':
> drivers/staging/dt3155/dt3155_drv.c:1091: error: implicit declaration
> of function 'free_irq'
> make[3]: *** [drivers/staging/dt3155/dt3155_drv.o] B³±d 1
> make[2]: *** [drivers/staging/dt3155] B³±d 2
> make[1]: *** [drivers/staging] B³±d 2
> make: *** [drivers] B³±d 2

BTW. Kernel 2.6.34-rc3-git6

>
>
> --
> Jan III Sobieski
>
> Signed-off-by: Jan III Sobieski <jan3sobi3ski@gmail.com>
>
> --- linux-2.6-git/drivers/staging/dt3155/dt3155_drv.c   2010-03-27
> 22:34:58.000000000 +0100
> +++ linux-2.6/drivers/staging/dt3155/dt3155_drv.c       2010-04-07
> 05:54:07.000000000 +0200
> @@ -74,6 +74,7 @@ MODULE_LICENSE("GPL");
>  #include <linux/types.h>
>  #include <linux/poll.h>
>  #include <linux/sched.h>
> +#include <linux/interrupt.h>
>
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
>



-- 
Jan III Sobieski
