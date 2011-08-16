Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1HPLKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 07:10:45 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27019 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1HPLKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 07:10:44 -0400
Date: Tue, 16 Aug 2011 13:11:03 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ravishankar <ravishankarkm32@gmail.com>
cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, root <root@localhost.localdomain>
Subject: Re: [PATCH 1/2] Staging: comedi: fix warning issue in cb_pcidda.c
In-Reply-To: <1313491962-7773-1-git-send-email-ravishankarkm32@gmail.com>
Message-ID: <alpine.LNX.2.00.1108161309300.23471@swampdragon.chaosbits.net>
References: <[PATCH]Staging: comedi:fix line over 80 character issue in cb_pcidda.c> <1313491962-7773-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011, Ravishankar wrote:

> From: root <root@localhost.localdomain>
> 

>From should be a real person.


> This is a patch to the cb_pcidda.c file that fixes up a line over 80 charcter warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/cb_pcidda.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
> index 9716f19..4882005 100644
> --- a/drivers/staging/comedi/drivers/cb_pcidda.c
> +++ b/drivers/staging/comedi/drivers/cb_pcidda.c
> @@ -51,9 +51,11 @@ Please report success/failure with other different cards to
>  #include "comedi_pci.h"
>  #include "8255.h"
>  
> -#define PCI_VENDOR_ID_CB	0x1307	/*  PCI vendor number of ComputerBoards */
> +/* PCI vendor number of ComputerBoards */
> +#define PCI_VENDOR_ID_CB        0x1307
>  #define EEPROM_SIZE	128	/*  number of entries in eeprom */
> -#define MAX_AO_CHANNELS 8	/*  maximum number of ao channels for supported boards */
> +/* maximum number of ao channels for supported boards */
> +#define MAX_AO_CHANNELS 8
>  

IMHO these comments are better placed where they were originally.


>  /* PCI-DDA base addresses */
>  #define DIGITALIO_BADRINDEX	2
> @@ -227,8 +229,10 @@ struct cb_pcidda_private {
>  	/* unsigned long control_status; */
>  	/* unsigned long adc_fifo; */
>  
> -	unsigned int dac_cal1_bits;	/*  bits last written to da calibration register 1 */
> -	unsigned int ao_range[MAX_AO_CHANNELS];	/*  current range settings for output channels */
> +	/* bits last written to da calibration register 1 */
> +	unsigned int dac_cal1_bits;
> +	/* current range settings for output channels */
> +	unsigned int ao_range[MAX_AO_CHANNELS];
>  	u16 eeprom_data[EEPROM_SIZE];	/*  software copy of board's eeprom */
>  };
>  
> @@ -378,7 +382,8 @@ found:
>  	printk(KERN_CONT " eeprom:");
>  	for (index = 0; index < EEPROM_SIZE; index++) {
>  		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
> -		printk(KERN_CONT " %i:0x%x ", index, devpriv->eeprom_data[index]);
> +		printk(KERN_CONT " %i:0x%x ", index,
> +				devpriv->eeprom_data[index]);
>  	}
>  	printk(KERN_CONT "\n");
>  
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

