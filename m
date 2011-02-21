Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1BUTcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:32:47 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48126 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab1BUTcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:32:45 -0500
Date: Mon, 21 Feb 2011 11:32:29 -0800
From: Andres Salomon <dilinger@queued.net>
To: Timo von Holtz <tvh@informatik.uni-kiel.de>
Cc: gregkh@suse.de, akpm@linux-foundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: olpc_dcon: fixed some coding style issues
Message-ID: <20110221113229.31403658@debxo>
In-Reply-To: <1298315591-11875-1-git-send-email-tvh@informatik.uni-kiel.de>
References: <1298315591-11875-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011 20:13:11 +0100
Timo von Holtz <tvh@informatik.uni-kiel.de> wrote:

> Fixed all coding style issues in the files
> drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
> drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
> 
> Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
> ---
>  drivers/staging/olpc_dcon/olpc_dcon_xo_1.c   |    2 +-
>  drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c |   84
> ++++++++++++++++---------- 2 files changed, 53 insertions(+), 33
> deletions(-)
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
> b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c index b154be7..ccde215
> 100644 --- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
> @@ -152,7 +152,7 @@ static void dcon_wiggle_xo_1(void)
>  	 * According to the cs5536 spec, to set GPIO14 to SMB_CLK we
> must
>  	 * simultaneously set AUX1 IN/OUT to GPIO14; ditto for
> SMB_DATA and
>  	 * GPIO15.
> - 	 */
> +	 */
>  	cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
>  	cs5535_gpio_set(OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_VAL);
>  	cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_ENABLE);
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
> b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c index e213b63..6381119
> 100644 --- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
> @@ -23,9 +23,10 @@
>  #include "olpc_dcon.h"
>  
>  /* Hardware setup on the XO 1.5:
> - * 	DCONLOAD connects to
> - *		VX855_GPIO1 (not SMBCK2)
> - * 	DCONBLANK connects to VX855_GPIO8 (not SSPICLK)  unused
> in driver
> + *	DCONLOAD connects to
> + *		VX855_GPO12 (not nCR_PWOFF)   (rev A)
> + *		VX855_GPIO1 (not SMBCK2)      (rev B)
> + *	DCONBLANK connects to VX855_GPIO8 (not SSPICLK)  unused in
> driver
>   *	DCONSTAT0 connects to VX855_GPI10 (not SSPISDI)
>   *	DCONSTAT1 connects to VX855_GPI11 (not nSSPISS)
>   *	DCONIRQ connects to VX855_GPIO12
> @@ -33,26 +34,32 @@
>   *	DCONSMBCLK connects to VX855 graphics CRTSPCLK
>   */
>  
> -#define VX855_GENL_PURPOSE_OUTPUT 0x44c // PMIO_Rx4c-4f
> -#define VX855_GPI_STATUS_CHG 0x450  // PMIO_Rx50
> -#define VX855_GPI_SCI_SMI 0x452  // PMIO_Rx52
> +#define TEST_B2 0   /* define to test B3 paths on a modded B2 board
> */ +

Nack.  Why are you re-adding TEST_B2 (as well as other stuff that was
removed)?

	
