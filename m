Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212Ab0KRUSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:18:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45182 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab0KRUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:18:39 -0500
Date: Thu, 18 Nov 2010 12:17:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] cx25821: fix build failure
Message-Id: <20101118121748.d1015435.randy.dunlap@oracle.com>
In-Reply-To: <ac9bb5b7fddd363c37c511e9af688128285fa1c1.1290110765.git.tim@klingt.org>
References: <ac9bb5b7fddd363c37c511e9af688128285fa1c1.1290110765.git.tim@klingt.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 21:15:58 +0100 Tim Blechmann wrote:

> include specific header for bkl functions
> 
> drivers/staging/cx25821/cx25821-video.c:815:8: error: implicit declaration of function ‘lock_kernel’
> drivers/staging/cx25821/cx25821-video.c:832:9: error: implicit declaration of function ‘unlock_kernel’
> 
> Signed-off-by: Tim Blechmann <tim@klingt.org>

Hi,

This patch has already been posted and is already merged into Linus's git tree.

Thanks.

> ---
>  drivers/staging/cx25821/cx25821-video.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/cx25821/cx25821-video.h b/drivers/staging/cx25821/cx25821-video.h
> index cc6034b..0df20dc 100644
> --- a/drivers/staging/cx25821/cx25821-video.h
> +++ b/drivers/staging/cx25821/cx25821-video.h
> @@ -34,6 +34,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
>  #include <linux/kthread.h>
> +#include <linux/smp_lock.h>
>  #include <asm/div64.h>
>  
>  #include "cx25821.h"
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
