Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab1D2XeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:34:17 -0400
Received: from kroah.org ([198.145.64.141]:46773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1D2XeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:34:16 -0400
Date: Fri, 29 Apr 2011 16:29:02 -0700
From: Greg KH <greg@kroah.com>
To: johnlinn@comcast.net
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, michal simek <michal.simek@petalogix.com>,
        joe@perches.com, grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
Message-ID: <20110429232902.GA24864@kroah.com>
References: <20110429211434.GA1355@kroah.com>
 <1369027353.2095897.1304114559625.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369027353.2095897.1304114559625.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:02:39PM +0000, johnlinn@comcast.net wrote:
> 
> > On Wed, Apr 27, 2011 at 12:17:36PM -0600, johnlinn@comcast.net wrote:
> > > From: John Linn <john.linn@xilinx.com>
> > > 
> > > The Xilinx PS Uart is used on the new ARM based SoC. This
> > > UART is not compatible with others such that a seperate
> > > driver is required.
> > > 
> > > Signed-off-by: John Linn <john.linn@xilinx.com>
> > 
> > I get build failures with this patch:
> > 
> >   CC [M]  drivers/tty/serial/xilinx_uartps.o
> > drivers/tty/serial/xilinx_uartps.c: In function ‘xuartps_get_port’:
> > drivers/tty/serial/xilinx_uartps.c:785:14: error: ‘NO_IRQ’ undeclared
> > (first use in this function)
> > drivers/tty/serial/xilinx_uartps.c:785:14: note: each undeclared
> > identifier is reported only once for each function it appears in
> > make[1]: *** [drivers/tty/serial/xilinx_uartps.o] Error 1
> > 
> > Care to fix this up so it's in a state I can properly apply it to the
> > tree?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Done and sent out as V5 of patch.
> 
> Just for future reference (and maybe I should know this).  How should I 
> have prevented this problem? I guess I would need to build the kernel 
> for other architectures and I don't normally do that.

Yes, you should at the very least, build the code for x86 as that's what
we use for development and applying the patches on.

You can use cross-compliers to build for other architectures as well if
you want.

thanks,

greg k-h
