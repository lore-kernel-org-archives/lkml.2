Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab0LPSEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:04:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52269 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab0LPSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:04:33 -0500
Date: Thu, 16 Dec 2010 10:03:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-media@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next v2] media: fix em28xx build, needs hardirq.h
Message-Id: <20101216100355.cd76fc70.randy.dunlap@oracle.com>
In-Reply-To: <20101207105009.7d634c7b.randy.dunlap@oracle.com>
References: <20101206140055.34289498.sfr@canb.auug.org.au>
	<AANLkTi=XkxnHZGTEsrrRmPGQePitzb=akyS99_Qd6ROy@mail.gmail.com>
	<20101207103815.26054c38.randy.dunlap@oracle.com>
	<20101207184453.GA30998@core2.telecom.by>
	<20101207105009.7d634c7b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010 10:50:09 -0800 Randy Dunlap wrote:

ping.


> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix em28xx build by adding hardirq.h header file:
> 
> drivers/media/video/em28xx/em28xx-vbi.c:49: error: implicit declaration of function 'in_interrupt'
> 
> Reported-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/media/video/em28xx/em28xx-vbi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20101207.orig/drivers/media/video/em28xx/em28xx-vbi.c
> +++ linux-next-20101207/drivers/media/video/em28xx/em28xx-vbi.c
> @@ -23,6 +23,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/hardirq.h>
>  #include <linux/init.h>
>  
>  #include "em28xx.h"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
