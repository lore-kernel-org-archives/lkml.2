Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1GFQBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:01:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab1GFQBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:01:40 -0400
Date: Wed, 6 Jul 2011 08:59:39 -0700
From: Greg KH <gregkh@suse.de>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 2/2] Staging: comedi: fix WARNING issue in icp_multi.c
Message-ID: <20110706155939.GC16625@suse.de>
References: <1309934026-2677-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309934026-2677-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 12:03:46PM +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the icp_multi.c file that fixes up a WARNING found by the checkpatch.pl tool

What warning?

> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/icp_multi.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
> index 126550f..78f33e7 100644
> --- a/drivers/staging/comedi/drivers/icp_multi.c
> +++ b/drivers/staging/comedi/drivers/icp_multi.c
> @@ -59,13 +59,12 @@ Options:
>  #include "icp_multi.h"
>  
>  #define DEVICE_ID	0x8000	/* Device ID */
> +#define ICP_MULTI_EXTDEBUG	/*       */
>  
> -#define ICP_MULTI_EXTDEBUG
> +/* Hardware types of the cards */
> +#define TYPE_ICP_MULTI 0
>  
> -/*  Hardware types of the cards */
> -#define TYPE_ICP_MULTI	0
> -
> -#define IORANGE_ICP_MULTI 	32
> +#define IORANGE_ICP_MULTI 32

These changes did not fix up any "warning", why did you make them?

greg k-h
