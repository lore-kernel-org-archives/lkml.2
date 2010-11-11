Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab0KKWYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:24:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44019 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab0KKWYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=XbKo2YA+G7IkFNwzIAC+xxCbHzREKPjNtRb5LIgesW9HDF9bS30UAHPbpyiBM6ep0S
         3ivE0+AXarhSSyTvoXSQzXWARkmmPJyNGZ4K3NHCAjp2aiPnH6mx/21q00BDr35jVolc
         TPbqzjJj0lOnZV/8czAAncoWCG+zhcmNWrBBc=
Date: Fri, 12 Nov 2010 01:24:07 +0300
From: Dan Carpenter <error27@gmail.com>
To: Damian Varayud <davarayud@gmail.com>
Cc: gregkh@suse.de, arun.thomas@gmail.com, ezemed7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix coding style issue in pcmuio.c
Message-ID: <20101111222407.GB3533@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Damian Varayud <davarayud@gmail.com>, gregkh@suse.de,
	arun.thomas@gmail.com, ezemed7@gmail.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1289485692-1527-1-git-send-email-user@netbu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289485692-1527-1-git-send-email-user@netbu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 11:28:12AM -0300, Damian Varayud wrote:
> This is a patch to the pcmuio.c file that fixes up braces, overlines
> and printk warnings found by the checkpatch.pl tool
> 
> Signed-off-by: Ezequiel Medina <ezemed7@gmail.com>
> ---

Looks basically Ok, but there are some few problems with the comments.

>  #define REG_INT_PENDING 0x6
> -#define REG_PAGELOCK 0x7	/* page selector register, upper 2 bits select a page
> -				   and bits 0-5 are used to 'lock down' a particular
> -				   port above to make it readonly.  */
> +#define REG_PAGELOCK 0x7/* page selector register, upper 2 bits select a page
> +			   and bits 0-5 are used to 'lock down' a particular
> +			   port above to make it readonly.  */

The original spacing was better.

>  	struct {
> -		int asic;	/* if non-negative, this subdev has an interrupt asic */
> +		int asic;	/* if non-negative, this subdev has an
> +				 * interrupt asic */
>  		int first_chan;	/* if nonnegative, the first channel id for
>  				   interrupts. */

Frankly I would just leave these as is since it's barely over the 80
char mark.  But if you really want to change them then linux multi-line
commenting style is described in Documentation/CodingStyle

The preferred style for long (multi-line) comments is:

        /*
         * This is the preferred style for multi-line
         * comments in the Linux kernel source code.
         * Please use it consistently.
         *
         * Description:  A column of asterisks on the left side,
         * with beginning and ending almost-blank lines.
         */

Please redo the comments and resend.

regards,
dan carpenter


