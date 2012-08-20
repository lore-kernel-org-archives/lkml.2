Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2HTOtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:49:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44536 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2HTOtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:49:41 -0400
Date: Mon, 20 Aug 2012 07:49:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3]: ezusb cleanup, FX2 support, firmware downloading
 support
Message-ID: <20120820144937.GB27266@kroah.com>
References: <20120815222055.GA22907@kroah.com>
 <7ea0bc18-451f-4025-885b-5071b82e8769@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ea0bc18-451f-4025-885b-5071b82e8769@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:52:56AM +0200, Rene Buergel wrote:
> ----- Ursprüngliche Mail -----
> > On Fri, Aug 03, 2012 at 05:06:27PM +0200, René Bürgel wrote:
> > > Hello,
> > > 
> > > this is a patches-series for controllers using the ezusb-functions.
> > > 
> > > ezusb:  remove dependency to usb_serial interface
> > > euzsb: add support for Cypress FX2LP
> > > ezusb: add functions for firmware download
> > 
> > Nice series, but your patches are white-space damaged, and I can't
> > apply
> > them at all.
> > 
> > Also, your third patch has the wrong Subject: line 
> > 
> > Care to resend them in a format that I can apply them in?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Thanks for reviewing it. 
> 
> I will check my email-settings and resend the patches.
> 
> I'm sorry about the wrong Subject line, this will be corrected when resending.
> 
> I got some further questions: 
> - Although i removed the dependency from ezusb to usb_serial,
>   ezusb.c still resides in drivers/usb/serial.
>   Can you give me a hint, where to put it instead?
>   I would like to do that with an additional patch.

Why do you want to move it?

> - is it fine to base the soon-to-be-resent patches on 3.6-rc2?

You should redo them against the linux-next tree, which has many more
patches than 3.6-rc2.

greg k-h
