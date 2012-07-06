Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab2GFWzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:55:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46316 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2GFWzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:55:36 -0400
Date: Fri, 6 Jul 2012 15:55:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: comedi: usbduxsigma: Syntax issue fixes
Message-ID: <20120706225532.GE10471@kroah.com>
References: <1340859660-28813-1-git-send-email-sebastianbenvenuti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340859660-28813-1-git-send-email-sebastianbenvenuti@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 02:01:00AM -0300, Sebastian Benvenuti wrote:
> fixed "many quoted string split across lines" issues,
> replaced "printk(KERN_ERR" for "pr_err("
> and replaced "printk(KERN_INFO" for "pr_info("
> 
> Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>

Where was...

Ok, you get the idea now.

Please fix up your patch numbering and resend these properly, in a
format that makes sense (hint, your current numbering made no sense...)

Also, stop doing:

>  			      this_usbduxsub->dux_commands, SIZEOFDUXBUFFER,
>  			      &nsent, BULK_TIMEOUT);
>  	if (result < 0)
> -		dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
> -			"could not transmit dux_command to the usb-device, "
> +		dev_err(&this_usbduxsub->interface->dev, "comedi%d: " \
> +			"could not transmit dux_command to the usb-device, " \
>  			"err=%d\n", this_usbduxsub->comedidev->minor, result);

The '\' stuff is pointless and wrong.

greg k-h
