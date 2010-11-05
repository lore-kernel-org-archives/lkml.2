Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0KENxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:53:49 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:57522 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0KENxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:53:47 -0400
X-Greylist: delayed 739 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 09:53:46 EDT
Subject: Re: [PATCH] leds-net5501: taints kernel, add license
From: Richard Purdie <rpurdie@rpsys.net>
To: Randy Dunlap <randy.dunlap@oracle.com>, akpm <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <20101104102800.6b1cc210.randy.dunlap@oracle.com>
References: <20101104102800.6b1cc210.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 13:40:26 +0000
Message-ID: <1288964426.28481.15863.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 10:28 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add MODULE_LICENSE() that matches file comments so that kernel
> is not tainted.
> 
> 	leds_net5501: module license 'unspecified' taints kernel.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Richard Purdie <rpurdie@linux.intel.com>

> ---
>  drivers/leds/leds-net5501.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Alessandro, why does this module not have a module_exit() function?
> I.e., why can it not be unloaded?
> 
> 
> --- lnx-2637-rc1.orig/drivers/leds/leds-net5501.c
> +++ lnx-2637-rc1/drivers/leds/leds-net5501.c
> @@ -92,3 +92,5 @@ unmap:
>  }
>  
>  arch_initcall(soekris_init);
> +
> +MODULE_LICENSE("GPL");
> 


