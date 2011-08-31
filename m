Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1HaNCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:02:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53878 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1HaNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:02:49 -0400
Subject: Re: [PATCH 2/2] Staging: comedi: fix line over 80 character issue
 in cb_pcidda.c
From: Sasha Levin <levinsasha928@gmail.com>
To: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1314791820-2780-1-git-send-email-ravishankar.km@greenturtles.in>
References: <[PATCH 2/2]Staging: comedi:fix line over 80 character issue in cb_pcidda.c>
	 <1314791820-2780-1-git-send-email-ravishankar.km@greenturtles.in>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 31 Aug 2011 16:02:42 +0300
Message-ID: <1314795762.14150.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 17:27 +0530, Ravishankar K Mallikarjunayya wrote:
> This is a patch to the cb_pcidda.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---

If you already bother fixing checkpatch warnings, please follow the
coding style guide (/Documentation/CodingStyle):

	The preferred style for long (multi-line) comments is:

		/*
		 * This is the preferred style for multi-line
		 * comments in the Linux kernel source code.
		 * Please use it consistently.
		 *
		 * Description:  A column of asterisks on the left side,
		 * with beginning and ending almost-blank lines.
		 */

>  drivers/staging/comedi/drivers/cb_pcidda.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
> index 661e945..847b5be 100644
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
> +#define MAX_AO_CHANNELS 8	/*  maximum number of ao channels for supported
> +				 *  boards */
>  
>  /* PCI-DDA base addresses */
>  #define DIGITALIO_BADRINDEX	2
> @@ -214,7 +216,8 @@ MODULE_DEVICE_TABLE(pci, cb_pcidda_pci_table);
>  
>  /* this structure is for data unique to this hardware driver.  If
>     several hardware drivers keep similar information in this structure,
> -   feel free to suggest moving the variable to the struct comedi_device struct.  */
> +   feel free to suggest moving the variable to the struct comedi_device
> +   struct.  */
>  struct cb_pcidda_private {
>  	int data;
>  
> @@ -241,13 +244,17 @@ struct cb_pcidda_private {
>  static int cb_pcidda_attach(struct comedi_device *dev,
>  			    struct comedi_devconfig *it);
>  static int cb_pcidda_detach(struct comedi_device *dev);
> -/* static int cb_pcidda_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
> +/* static int cb_pcidda_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
> + * struct comedi_insn *insn, unsigned int *data);
> + */
>  static int cb_pcidda_ao_winsn(struct comedi_device *dev,
>  			      struct comedi_subdevice *s,
>  			      struct comedi_insn *insn, unsigned int *data);
>  
>  /* static int cb_pcidda_ai_cmd(struct comedi_device *dev, struct *comedi_subdevice *s);*/
> -/* static int cb_pcidda_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s, struct comedi_cmd *cmd); */
> +/* static int cb_pcidda_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
> + * struct comedi_cmd *cmd);
> + */
>  /* static int cb_pcidda_ns_to_timer(unsigned int *ns,int *round); */
>  
>  static unsigned int cb_pcidda_serial_in(struct comedi_device *dev);
> @@ -491,7 +498,9 @@ static int cb_pcidda_ai_cmdtest(struct comedi_device *dev,
>  	if (err)
>  		return 1;
>  
> -	/* step 2: make sure trigger sources are unique and mutually compatible */
> +	/* step 2: make sure trigger sources are unique and mutually
> +	 * compatible
> +	 */
>  
>  	/* note that mutual compatibility is not an issue here */
>  	if (cmd->scan_begin_src != TRIG_TIMER

-- 

Sasha.

