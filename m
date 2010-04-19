Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0DSRQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:16:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab0DSRQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:16:09 -0400
Date: Mon, 19 Apr 2010 10:15:03 -0700
From: Greg KH <gregkh@suse.de>
To: Maurice Dawson <mauricedawson2699@googlemail.com>
Cc: wfp5p@virginia.edu, mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 32/32] Staging: comedi: fix EXPORT_SYMBOL(FOO) coding
 style issues in ni_labpc.c
Message-ID: <20100419171501.GB13162@suse.de>
References: <1271695748-3202-1-git-send-email-mauricedawson2699@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271695748-3202-1-git-send-email-mauricedawson2699@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 05:49:08PM +0100, Maurice Dawson wrote:
> This is a re-submitted patch to the ni_labpc.c file that fixes EXPORT_SYMBOL(FOO) warnings found by the checkpatch.pl tool
> 
> Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
> ---
>  drivers/staging/comedi/drivers/ni_labpc.c |   31 +++++++++++++++--------------
>  1 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
> index becbe47..26e02d9 100644
> --- a/drivers/staging/comedi/drivers/ni_labpc.c
> +++ b/drivers/staging/comedi/drivers/ni_labpc.c
> @@ -314,7 +314,6 @@ const int labpc_1200_is_unipolar[NUM_LABPC_1200_AI_RANGES] = {
>  	1,
>  	1,
>  };
> -
>  /* map range index to gain bits */
>  const int labpc_1200_ai_gain_bits[NUM_LABPC_1200_AI_RANGES] = {
>  	0x00,

Why remove this line?  Did that change any warning?

You also do that for a lot of other lines in this file, which isn't
good.

How about only fixing the warnings, and not mushing other lines up.

thanks,

greg k-h
