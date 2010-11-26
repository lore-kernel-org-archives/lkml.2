Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0KZKQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:16:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:52937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab0KZKQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:16:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,260,1288594800"; 
   d="scan'208";a="577814627"
Date: Fri, 26 Nov 2010 11:16:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>
Subject: Re: [PATCH 1/2] mfd: Include <linux/io.h> instead of <asm/io.h>
Message-ID: <20101126101632.GC5520@sortiz-mobl>
References: <1289375271.28822.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289375271.28822.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Nov 10, 2010 at 03:47:51PM +0800, Axel Lin wrote:
> As warned by checkpatch.pl, use #include <linux/io.h> instead of <asm/io.h>
Thanks a lot, both patches applied.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/sm501.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
> index bc9275c..c24bed7 100644
> --- a/drivers/mfd/sm501.c
> +++ b/drivers/mfd/sm501.c
> @@ -26,7 +26,7 @@
>  #include <linux/sm501-regs.h>
>  #include <linux/serial_8250.h>
>  
> -#include <asm/io.h>
> +#include <linux/io.h>
>  
>  struct sm501_device {
>  	struct list_head		list;
> -- 
> 1.7.2
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
