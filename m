Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0ECTdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:33:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1856 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab0ECTdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:33:31 -0400
Subject: Re: Patch for wlan-ng/hfa384x_usb.c
From: Joe Perches <joe@perches.com>
To: adam.latham@unisontorbay.org.uk
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Elwell <Andrew.Elwell@gmail.com>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Svenne Krap <svenne@krap.dk>, Jiri Kosina <jkosina@suse.cz>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1272911432.1902.1.camel@ubuntu.ubuntu-domain>
References: <1272911432.1902.1.camel@ubuntu.ubuntu-domain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 12:33:30 -0700
Message-ID: <1272915210.30040.164.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 19:30 +0100, Adam Latham wrote:
> Subject: [PATCH] Staging: wlan-ng: fix various whitespace and 80 char issues in hfa384x_usb.c
> This is a patch to fix various whitespace and 80 character style issues found by checkpatch.pl tool
> Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>

Hi Adam.

> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 5df56f0..b7a319f 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
[]
> @@ -451,7 +451,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
>  	if (test_bit(WORK_RX_HALT, &hw->usb_flags)) {
>  		int ret;
>  
> -		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock! */
> +		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock!*/

It's most common to use a space before the trailing */

> @@ -2619,7 +2619,7 @@ int hfa384x_drvr_start(hfa384x_t *hw)
>  			pr_debug("First cmd_initialize() failed (result %d),\n",
>  				 result1);
>  			pr_debug
> -			    ("but second attempt succeeded. All should be ok\n");
> +			    ("but second attempt succeeded.All should be ok\n");

Removing the space after a period here is not an improvement.


