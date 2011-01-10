Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1AJGiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 01:38:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:41512 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1AJGit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 01:38:49 -0500
Date: Sun, 9 Jan 2011 22:36:16 -0800
From: Greg KH <gregkh@suse.de>
To: ahern.michael.t@gmail.com
Cc: u.kleine-koenig@pengutronix.de, julia@diku.dk, nikai@nikai.net,
        morgan.gatti@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: comedi: fix line-length coding style
 issue in usbduxfast.c
Message-ID: <20110110063616.GB3016@suse.de>
References: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:03:12AM +1100, ahern.michael.t@gmail.com wrote:
> From: mah <ahern.michael.t@gmail.com>

Please put your "real" name here, the same one you put down below in the
Signed-off-by: line.

> This patch to usbduxfast.c file that fixes warnings found by checkpatch.pl tool

Which warnings?

> -static void usbduxfast_firmware_request_complete_handler(const struct firmware
> +static void usbduxfast_firmware_req_complete_handler(const struct firmware
>  							 *fw, void *context)
>  {
>  	struct usbduxfastsub_s *usbduxfastsub_tmp = context;
> @@ -1577,7 +1585,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
>  				      &udev->dev,
>  				      GFP_KERNEL,
>  				      usbduxfastsub + index,
> -				      usbduxfast_firmware_request_complete_handler);
> +				      usbduxfast_firmware_req_complete_handler);

Renaming the function name just to make the line-length work isn't ok.
Just don't make this change.

thanks,

greg k-h
