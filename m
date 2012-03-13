Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300Ab2CMWoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:44:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41043 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab2CMWoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:44:15 -0400
Date: Tue, 13 Mar 2012 15:44:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Miller <amiller@amilx.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix spacing issue
Message-ID: <20120313224411.GB12677@kroah.com>
References: <1331441798-3507-1-git-send-email-amiller@amilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331441798-3507-1-git-send-email-amiller@amilx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 11:56:38PM -0500, Andrew Miller wrote:
> Fix spacing coding style issues
> 
> Signed-off-by: Andrew Miller <amiller@amilx.com>
> ---
>  drivers/staging/rtl8187se/r8180_core.c |   46 +++++++++++++++++--------------
>  1 files changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> index 05f25eb..6a0c592 100644
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -2617,28 +2617,32 @@ void watch_dog_adaptive(unsigned long data)
>  }
>  
>  static CHANNEL_LIST ChannelPlan[] = {
> -	{{1,2,3,4,5,6,7,8,9,10,11,
> -	36,40,44,48,52,56,60,64},19},		/* FCC */
> -	{{1,2,3,4,5,6,7,8,9,10,11},11},		/* IC */
> -	{{1,2,3,4,5,6,7,8,9,10,11,
> -	12,13,36,40,44,48,52,56,60,64},21},	/* ETSI */
> -	{{1,2,3,4,5,6,7,8,9,10,11,
> -	12,13,36,40,44,48,52,56,60,64},21},	/* Spain. Change to ETSI. */
> -	{{1,2,3,4,5,6,7,8,9,10,11,
> -	12,13,36,40,44,48,52,56,60,64},21},	/* France. Change to ETSI. */
> -	{{14,36,40,44,48,52,56,60,64},9},	/* MKK */
> -	{{1,2,3,4,5,6,7,8,9,10,11,
> -	12,13,14, 36,40,44,48,52,56,60,64},22}, /* MKK1 */
> -	{{1,2,3,4,5,6,7,8,9,10,11,
> -	12,13,36,40,44,48,52,56,60,64},21},	/* Israel. */
> -	{{1,2,3,4,5,6,7,8,9,10,11,
> -	12,13,34,38,42,46},17},			/* For 11a , TELEC */
> -	{{1,2,3,4,5,6,7,8,9,10,11,
> -	12,13,14},14},  /* For Global Domain. 1-11:active scan,
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
> +	36, 40, 44, 48, 52, 56, 60, 64}, 19},	/* FCC */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11}, /* IC */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
> +	12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21}, /* ETSI */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
> +	12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21}, /* Spain. Change
> +						       * to ETSI. */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
> +	12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21}, /* France. Change
> +						       * to ETSI. */
> +	{{ 14, 36, 40, 44, 48, 52, 56, 60, 64}, 9}, /* MKK */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
> +	12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22}, /* MKK1 */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
> +	12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21}, /* Israel. */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
> +	12, 13, 34, 38, 42, 46}, 17},		/* For 11a , TELEC */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
> +	12, 13, 14}, 14},  /* For Global Domain. 1-11:active scan,

That's easier to read?  Not to me, how about putting them each on one
line?  Yes, that makes for longer lines, but it makes more sense, right?

And what's with the first ' ' on each set of numbers?

>  			 * 12-14 passive scan. //+YJ, 080626 */
> -	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13} /* world wide 13: ch1~ch11 active
> -					      * scan, ch12~13 passive //lzm
> -					      * add 080826 */
> +	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13} /* world wide 13:
> +							    * ch1~ch11 active
> +					      		    * scan, ch12~13
> +					      		    * passive //lzm
> +					      		    * add 080826 */

That makes the comment impossible to read.

Please be smarter, this is to be done to make it easy for humans, not to
just blindly follow a tool's "warnings".

thanks,

greg k-h
