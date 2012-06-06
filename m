Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab2FFWye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:54:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38093 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2FFWyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:54:32 -0400
Date: Thu, 7 Jun 2012 07:54:26 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, oneukum@suse.de, alan@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 04/11] remove usb_interface pointer
Message-ID: <20120606225426.GA8270@kroah.com>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
 <1339000032-10313-5-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339000032-10313-5-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 06:27:05PM +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> this saves a litte bit of memory space in the driver devices structure
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  drivers/usb/usb-skeleton.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
> index 2f17991..f7fe32f 100644
> --- a/drivers/usb/usb-skeleton.c
> +++ b/drivers/usb/usb-skeleton.c
> @@ -49,7 +49,6 @@ MODULE_DEVICE_TABLE(usb, skel_table);
>  /* Structure to hold all of our device specific stuff */
>  struct usb_skel {
>  	struct usb_device	*udev;			/* the usb device for this device */
> -	struct usb_interface	*interface;		/* the interface for this device */

No, that's the exact opposite of what I asked you to do.

