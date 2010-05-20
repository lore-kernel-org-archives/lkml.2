Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0ETPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:09:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0ETPJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:09:56 -0400
Date: Thu, 20 May 2010 08:06:44 -0700
From: Greg KH <gregkh@suse.de>
To: Neil Munro <neilmunro@gmail.com>
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1586/1586] Staging: RT2860: Fixed my previous patch.
Message-ID: <20100520150644.GA3862@suse.de>
References: <1274354933-24377-1-git-send-email-neilmunro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274354933-24377-1-git-send-email-neilmunro@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 12:28:53PM +0100, Neil Munro wrote:
> From: Niadh <neilmunro@gmail.com>
> 
> I have corrected the confusion between braces and parethesis. In
> addition I have removed a few warnings where the lines were over 80
> lines and finaly have implemented a few suggestions Joe Perches
> suggested (thanks Joe).
> 
> Signed-off-by: Neil Munro <neilmunro@gmail.com>
> ---
>  drivers/staging/rt2860/mlme.h |   89 +++++++++++++++++++++++++----------------
>  1 files changed, 55 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/staging/rt2860/mlme.h b/drivers/staging/rt2860/mlme.h
> index 63cada3..02cbe9a 100644
> --- a/drivers/staging/rt2860/mlme.h
> +++ b/drivers/staging/rt2860/mlme.h
> @@ -31,7 +31,7 @@
> 
>  	Revision History:
>  	Who			When			What
> -	--------	----------		----------------------------------------------
> +	--------	----------		------------
>  	John Chang	2003-08-28		Created
>  	John Chang  2004-09-06      modified for RT2600
> 
> @@ -49,8 +49,9 @@
>  #define LFSR_MASK                   0x80000057
>  #define MLME_TASK_EXEC_INTV         100/*200*/	/* */
>  #define LEAD_TIME                   5
> -#define MLME_TASK_EXEC_MULTIPLE       10  /*5*/	/* MLME_TASK_EXEC_MULTIPLE * MLME_TASK_EXEC_INTV = 1 sec */
> -#define REORDER_EXEC_INTV         	100	/* 0.1 sec */
> +#define MLME_TASK_EXEC_MULTIPLE       10
> +/*5*/	/* MLME_TASK_EXEC_MULTIPLE * MLME_TASK_EXEC_INTV = 1 sec */

This doesn't make sense.  Put the comment on the line before.

And drop the /*5*/, it too doesn't make sense.

> +#define REORDER_EXEC_INTV		100	/* 0.1 sec */
> 
>  /* The definition of Radar detection duration region */
>  #define CE		0
> @@ -60,7 +61,7 @@
>  #define JAP_W56	4
>  #define MAX_RD_REGION 5
> 
> -#define BEACON_LOST_TIME            { 4 * OS_HZ }	/* 2048 msec = 2 sec */
> +#define BEACON_LOST_TIME            (4 * OS_HZ)	/* 2048 msec = 2 sec */

As I didn't take your original patch, this patch will not apply.  Please
generate a new patch that I can apply properly to the linux-next tree.

thanks,

greg k-h
