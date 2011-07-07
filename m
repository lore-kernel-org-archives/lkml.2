Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1GGNpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:45:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44565 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1GGNpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:45:53 -0400
Date: Thu, 7 Jul 2011 16:44:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        Ravishankar <ravishankarm32@gmail.com>, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 7/7] Staging: comedi: fix warning issue in unioxx5.c
Message-ID: <20110707134439.GM18655@shale.localdomain>
References: <1310036797-15964-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310036797-15964-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 04:36:37PM +0530, Ravishankar wrote:
>  struct unioxx5_subd_priv {
>  	int usp_iobase;
> -	unsigned char usp_module_type[12];	/* 12 modules. each can be 70L
> -						 * or 73L
> -						*/
> -	unsigned char usp_extra_data[12][4];	/* for saving previous written
> -						 * value for analog modules
> -						*/
> +	/* 12 modules. each can be 70L or 73L */
> +	unsigned char usp_module_type[12];
> +
> +	/*for saving previous written value for analog modules */
> +	unsigned char usp_extra_data[12][4];
> +
> +
>  

I wouldn't comment on this except that it occurs in several places.

Don't introduce extra blank lines here.  As a general rule we never
want two blank lines in a row (we have blank lines 3 here).

Also the original patch should have been redone instead of putting
this patch on top of the other.  To redo a patch use the following
subject line:
[PATCH 7/7 v2] Staging: comedi: fix warning issue in unioxx5.c
Then after the signed off by line but infront of the patch put 
three dashes and an explanation why it was redone:
---
v2:  Dan Carpenter was whining and complaining about v1 like a
spoiled little tweenager.

regards,
dan carpenter

