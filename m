Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0ELIUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:20:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:34141 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab0ELIUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:20:40 -0400
Date: Wed, 12 May 2010 10:20:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Morgan Gatti <morgan.gatti@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:comedi:Fix bug and coding style issue in usbdux.c
 This is a patch to the usbdux.c file that resolve 2 errors in coding and
 fix the warning about lengt of code lines Signed-off-by: Morgan Gatti
 <morgan.gatti@gmail.com>
In-Reply-To: <1273614953-3263-1-git-send-email-morgan.gatti@gmail.com>
Message-ID: <alpine.LNX.2.00.1005121015350.28092@pobox.suse.cz>
References: <patch usbdux> <1273614953-3263-1-git-send-email-morgan.gatti@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Morgan Gatti wrote:

> ---
>  drivers/staging/comedi/drivers/usbdux.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

Morgan,

please look into fixing you patch submission tools -- the whole changelog, 
including your Signed-off-by: line, ended up in Subject:, which is 
probably not what you intended.

> diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
> index 8942ae4..c39c36a 100644
> --- a/drivers/staging/comedi/drivers/usbdux.c
> +++ b/drivers/staging/comedi/drivers/usbdux.c
> @@ -793,7 +793,7 @@ static int usbduxsub_stop(struct usbduxsub *usbduxsub)
>  }
>  
>  static int usbduxsub_upload(struct usbduxsub *usbduxsub,
> -			    uint8_t * local_transfer_buffer,
> +			    uint8_t *local_transfer_buffer,
>  			    unsigned int startAddr, unsigned int len)
>  {
>  	int errcode;
> @@ -825,7 +825,7 @@ static int usbduxsub_upload(struct usbduxsub *usbduxsub,
>  #define FIRMWARE_MAX_LEN 0x2000
>  
>  static int firmwareUpload(struct usbduxsub *usbduxsub,
> -			  const u8 * firmwareBinary, int sizeFirmware)
> +			  const u8 *firmwareBinary, int sizeFirmware)

While you are performing the glorious task of fixing the coding style in 
this driver, maybe also converting it not to use CamelNamingConvention 
would be worthwile.

>  {
>  	int ret;
>  	uint8_t *fwBuf;
> @@ -835,7 +835,7 @@ static int firmwareUpload(struct usbduxsub *usbduxsub,
>  
>  	if (sizeFirmware > FIRMWARE_MAX_LEN) {
>  		dev_err(&usbduxsub->interface->dev,
> -			"comedi_: usbdux firmware binary it too large for FX2.\n");
> +		"comedi_: usbdux firmware binary it too large for FX2.\n");
>  		return -ENOMEM;
>  	}
>  
> @@ -1264,8 +1264,8 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
>  			    (this_usbduxsub->ai_interval) * 2;
>  		}
>  		this_usbduxsub->ai_timer = cmd->scan_begin_arg / (125000 *
> -								  (this_usbduxsub->
> -								   ai_interval));
> +					  (this_usbduxsub->
> +					   ai_interval));

Pasting this to one line would improve readability.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
