Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1DLTNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:13:53 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:36327 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab1DLTNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:13:52 -0400
Date: Tue, 12 Apr 2011 12:13:41 -0700
From: Andres Salomon <dilinger@queued.net>
To: "Stefan =?ISO-8859-1?Q?Br=E4hler?=" <stefan.braehler@googlemail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Stefan =?ISO-8859-1?Q?Br=E4hler?= <Stefan.Braehler@gmail.com>
Subject: Re: [PATCH] staging: olpc_dcon: fix space and coding issues
Message-ID: <20110412121341.68fb2f6a@debxo>
In-Reply-To: <1302630811-15750-1-git-send-email-Stefan.Braehler@gmail.com>
References: <1302630811-15750-1-git-send-email-Stefan.Braehler@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, thanks.

Acked-by: Andres Salomon <dilinger@queued.net>

On Tue, 12 Apr 2011 19:53:31 +0200
"Stefan Brähler" <stefan.braehler@googlemail.com> wrote:

> Fix the whitespace and coding style issues in olpc_dcon metioned by
> checkpatch.
> 
> Signed-off-by: Stefan Brähler <Stefan.Braehler@gmail.com>
> ---
>  drivers/staging/olpc_dcon/olpc_dcon_xo_1.c   |    2 +-
>  drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c |   22
> ++++++++++------------ 2 files changed, 11 insertions(+), 13
> deletions(-)
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
> b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c index b5d21f6..f4e9747
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
> b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c index 7aa9b1a..a6a6cf2
> 100644 --- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
> @@ -24,9 +24,8 @@
>  #include "olpc_dcon.h"
>  
>  /* Hardware setup on the XO 1.5:
> - * 	DCONLOAD connects to
> - *		VX855_GPIO1 (not SMBCK2)
> - * 	DCONBLANK connects to VX855_GPIO8 (not SSPICLK)  unused
> in driver
> + *	DCONLOAD connects to VX855_GPIO1 (not SMBCK2)
> + *	DCONBLANK connects to VX855_GPIO8 (not SSPICLK)  unused in
> driver
>   *	DCONSTAT0 connects to VX855_GPI10 (not SSPISDI)
>   *	DCONSTAT1 connects to VX855_GPI11 (not nSSPISS)
>   *	DCONIRQ connects to VX855_GPIO12
> @@ -34,9 +33,9 @@
>   *	DCONSMBCLK connects to VX855 graphics CRTSPCLK
>   */
>  
> -#define VX855_GENL_PURPOSE_OUTPUT 0x44c // PMIO_Rx4c-4f
> -#define VX855_GPI_STATUS_CHG 0x450  // PMIO_Rx50
> -#define VX855_GPI_SCI_SMI 0x452  // PMIO_Rx52
> +#define VX855_GENL_PURPOSE_OUTPUT 0x44c /* PMIO_Rx4c-4f */
> +#define VX855_GPI_STATUS_CHG 0x450  /* PMIO_Rx50 */
> +#define VX855_GPI_SCI_SMI 0x452  /* PMIO_Rx52 */
>  #define BIT_GPIO12 0x40
>  
>  #define PREFIX "OLPC DCON:"
> @@ -63,8 +62,7 @@ static int dcon_init_xo_1_5(struct dcon_priv *dcon)
>  	unsigned int irq;
>  	u_int8_t tmp;
>  	struct pci_dev *pdev;
> -	
> -	
> +
>  	pdev = pci_get_device(PCI_VENDOR_ID_VIA,
>  			      PCI_DEVICE_ID_VIA_VX855, NULL);
>  	if (!pdev) {
> @@ -149,7 +147,7 @@ static void dcon_wiggle_xo_1_5(void)
>  	 * state machine to reset to a (sane) initial state.  Mitch
> Bradley
>  	 * did some testing and discovered that holding for 16
> SMB_CLK cycles
>  	 * worked a lot more reliably, so that's what we do here.
> - 	 */
> +	 */
>  	set_i2c_line(1, 1);
>  
>  	for (x = 0; x < 16; x++) {
> @@ -172,13 +170,13 @@ static void dcon_set_dconload_xo_1_5(int val)
>  static u8 dcon_read_status_xo_1_5(void)
>  {
>  	u8 status;
> -	
> +
>  	if (!dcon_was_irq())
>  		return -1;
>  
> -	// i believe this is the same as "inb(0x44b) & 3"
> +	/* i believe this is the same as "inb(0x44b) & 3" */
>  	status = gpio_get_value(VX855_GPI(10));
> -	status |= gpio_get_value(VX855_GPI(11)) << 1; 
> +	status |= gpio_get_value(VX855_GPI(11)) << 1;
>  
>  	dcon_clear_irq();
>  

