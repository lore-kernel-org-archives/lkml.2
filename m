Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab2ISUGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:06:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64122 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2ISUGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:06:34 -0400
Date: Wed, 19 Sep 2012 21:06:27 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB: ezusb: move ezusb.c from drivers/usb/serial to
 drivers/usb/misc
Message-ID: <20120919200627.GB17827@kroah.com>
References: <20120918163732.GA28387@kroah.com>
 <23459b4f-b303-4b3b-a0ef-152064209bb3@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23459b4f-b303-4b3b-a0ef-152064209bb3@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 08:23:07PM +0200, Rene Buergel wrote:
> > I get the following build errors with
> > this patch applied:
> > 
> > ERROR: "ezusb_fx1_ihex_firmware_download"
> > [drivers/usb/serial/whiteheat.ko] undefined!
> > ERROR: "ezusb_fx1_ihex_firmware_download"
> > [drivers/usb/serial/keyspan_pda.ko] undefined!
> > ERROR: "ezusb_fx1_set_reset" [drivers/usb/serial/keyspan_pda.ko]
> > undefined!
> > ERROR: "ezusb_fx1_ihex_firmware_download"
> > [drivers/usb/serial/keyspan.ko] undefined!
> > 
> 
> I unfortunately can't reproduce these errors, neither using bool nor tristate
> for the setting in Kconfig. I did a clean build.
> Can you provide more information on when/how they occur? Can you send a .config?

I can't as I don't have the patch anymore, nor the same config.  Care to
resend it after fixing the bool Kconfig option and I'll see if I can
reproduce it?

Also be sure to cc: me so that I don't miss the patch.

thanks,

greg k-h
