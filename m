Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab1GGJDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:03:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38500 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1GGJDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:03:09 -0400
Date: Thu, 7 Jul 2011 12:01:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 5/5] Staging: comedi: fix warning issue in unioxx5.c
Message-ID: <20110707090156.GK18655@shale.localdomain>
References: <1310022039-25599-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310022039-25599-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 12:30:39PM +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the unioxx5.c file that fixes up a  warning:line over 80 charcter found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/unioxx5.c |   25 ++++++++++++++++++-------
>  1 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
> index 598884e..9b311c7 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -75,8 +75,13 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
>  /* 'private' structure for each subdevice */
>  struct unioxx5_subd_priv {
>  	int usp_iobase;
> -	unsigned char usp_module_type[12];	/* 12 modules. each can be 70L or 73L */
> -	unsigned char usp_extra_data[12][4];	/* for saving previous written value for analog modules */
> +	unsigned char usp_module_type[12];	/* 12 modules. each can be 70L
> +						 * or 73L
> +						*/
                                                ^^^
	The asterisks should line up.  Maybe move the comment to the
	line before.

	/* 12 modules. each can be 70L or 73L */
	unsigned char usp_module_type[12];

regards,
dan carpenter


