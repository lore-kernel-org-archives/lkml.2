Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2FRX7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:59:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63342 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2FRX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:59:06 -0400
Date: Mon, 18 Jun 2012 16:59:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk, fmhess@users.sourceforge.net
Subject: Re: [PATCH 1/4] staging: comedi: Kconfig: menuconfig options should
 be bool not tristate
Message-ID: <20120618235902.GA29679@kroah.com>
References: <201206151520.04455.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206151520.04455.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 03:20:04PM -0700, H Hartley Sweeten wrote:
> The menuconfig options to enable the misc, isa, pci, pcmcia, and usb
> comedi driver selections should be bool not tristate. They don't
> directly affect the building of the kernel they just allow other
> options to be selected.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
> ---
>  drivers/staging/comedi/Kconfig |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

This patch breaks the build for me with lots of the following errors:
ERROR: "subdev_8255_init" [drivers/staging/comedi/drivers/adl_pci7296.ko] undefined!
ERROR: "subdev_8255_cleanup" [drivers/staging/comedi/drivers/adl_pci7296.ko] undefined!

So I can't take it, or the other 4 patches in this series, sorry.

Care to redo it?

thanks,

greg k-h
