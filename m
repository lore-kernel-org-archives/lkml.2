Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2KLXQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:16:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58981 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2KLXQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:16:06 -0500
Date: Mon, 12 Nov 2012 15:16:33 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Meelis Roos <mroos@linux.ee>,
        =?iso-8859-1?Q?Ren=E9_B=FCrgel?= <rene.buergel@sohard.de>
Cc: linux-usb@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.7-rc5 modpost/link failure: ezusb
Message-ID: <20121112231633.GD4040@kroah.com>
References: <alpine.SOC.1.00.1211121538140.11001@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.SOC.1.00.1211121538140.11001@math.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 03:44:35PM +0200, Meelis Roos wrote:
>   MODPOST 490 modules
> ERROR: "ezusb_fx1_ihex_firmware_download" [drivers/usb/serial/whiteheat.ko] undefined!
> ERROR: "ezusb_fx1_ihex_firmware_download" [drivers/usb/serial/keyspan_pda.ko] undefined!
> ERROR: "ezusb_fx1_set_reset" [drivers/usb/serial/keyspan_pda.ko] undefined!
> ERROR: "ezusb_fx1_ihex_firmware_download" [drivers/usb/serial/keyspan.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> This happens when these USB modules have been selected to be modular and 
> CONFIG_USB_EZUSB_FX2 is linked in. Full config below.

Odd, the symbols are properly exported from ezusb.c, so I don't
understand why they are not showing up here.

René, care to take a look at this?

thanks,

greg k-h
