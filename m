Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab0G0ETn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:19:43 -0400
Received: from kroah.org ([198.145.64.141]:48578 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0G0ETm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:19:42 -0400
Date: Mon, 26 Jul 2010 21:17:40 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: failed import of the usb quilt series
Message-ID: <20100727041740.GD16038@kroah.com>
References: <20100727104236.eeccabdf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727104236.eeccabdf.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 10:42:36AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Importing the usb quilt series today produced this error:
> 
> usb-serial-enabling-support-for-segway-rmp-in-ftdi_sio.patch
> error: patch failed: drivers/usb/serial/ftdi_sio.c:746
> error: drivers/usb/serial/ftdi_sio.c: patch does not apply
> Context reduced to (1/0) to apply fragment at 1012
> 
> I removed that patch for today.

Thanks, yes, this is a known issue, it conflicts with a patch that I
sent to Linus that is already in his tree.  I'll resync tomorrow with
the latest -git snapshot and it should work.

thanks,

greg k-h
