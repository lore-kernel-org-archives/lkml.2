Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab2KVS0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:26:37 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42600 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KVS0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:26:33 -0500
Date: Thu, 22 Nov 2012 10:27:44 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH] ezusb: add dependency to USB
Message-ID: <20121122182744.GA25505@kroah.com>
References: <6ea638d3-6ab4-42af-aadb-398cc8593f08@shmail0>
 <f90b1aa6-492d-4431-9334-cfcfa4a92b9a@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f90b1aa6-492d-4431-9334-cfcfa4a92b9a@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 07:10:50PM +0100, Rene Buergel wrote:
> This fixes an error during modpost, when ezusb is built into the kernel while USB is built as module.
> 
> Signed-off-by: René Bürgel <rene.buergel@sohard.de>
> --
> diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
> index a8f0523..fecde69 100644
> --- a/drivers/usb/misc/Kconfig
> +++ b/drivers/usb/misc/Kconfig
> @@ -246,6 +246,7 @@ config USB_YUREX
> 
>  config USB_EZUSB_FX2
>  	tristate "Functions for loading firmware on EZUSB chips"
> +	depends on USB

Ah, that makes sense, thanks for the fix, I'll queue it up for 3.8 and
backport it for 3.7-stable as well.

thanks,

greg k-h
