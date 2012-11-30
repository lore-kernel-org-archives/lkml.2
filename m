Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2K3CIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:08:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2K3CIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:08:52 -0500
Date: Thu, 29 Nov 2012 18:08:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Laurent Navet [Mali]" <laurent.navet@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: Fix checkpatch.pl switch - case issue
Message-ID: <20121130020848.GA2056@kroah.com>
References: <1354188082-2655-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354188082-2655-1-git-send-email-laurent.navet@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:21:22PM +0100, Laurent Navet [Mali] wrote:
> From: "Laurent Navet [Mali]" <laurent.navet@gmail.com>
> 
> delete old commentted code to avoid this checkpatch error :
>  line6/pcm.c:423: ERROR: switch and case should be at the same indent
> 
> Signed-off-by: Laurent Navet [Mali] <laurent.navet@gmail.com>

What is the [Mali] thing for?

> ---
>  drivers/staging/line6/pcm.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
> index 6c1e313..a0ce781 100644
> --- a/drivers/staging/line6/pcm.c
> +++ b/drivers/staging/line6/pcm.c
> @@ -455,14 +455,6 @@ int line6_init_pcm(struct usb_line6 *line6,
>  		ep_write = 0x01;
>  		break;
>  
> -		/* this is for interface_number == 1:
> -		   case LINE6_DEVID_TONEPORT_UX2:
> -		   case LINE6_DEVID_PODSTUDIO_UX2:
> -		   ep_read  = 0x87;
> -		   ep_write = 0x00;
> -		   break;
> -		 */

Why not properly indent it to keep the comment around instead?

thanks,

greg k-h
