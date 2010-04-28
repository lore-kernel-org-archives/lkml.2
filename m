Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0D1PtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:49:15 -0400
Received: from kroah.org ([198.145.64.141]:51441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab0D1PtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:49:04 -0400
Date: Wed, 28 Apr 2010 08:28:09 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tobias Klauser <tklauser@distanz.ch>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20100428152809.GF4483@kroah.com>
References: <20100427141224.834a102a.sfr@canb.auug.org.au>
 <20100427151305.GA7653@kroah.com>
 <20100428161425.eff4c40a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428161425.eff4c40a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:14:25PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Tue, 27 Apr 2010 08:13:05 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Tue, Apr 27, 2010 at 02:12:24PM +1000, Stephen Rothwell wrote:
> > > 
> > > After merging the staging tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > ERROR: "uart_console_device" [drivers/serial/altera_uart.ko] undefined!
> > > ERROR: "uart_console_device" [drivers/serial/altera_jtaguart.ko] undefined!
> > > 
> > > Introduced by commits 76bdbd933febe791fee114e7bb6c42bbd1a3f4f3 ("serial:
> > > Add driver for the Altera UART") and
> > > 11c59b34b299d7214b466cf799410a9a540476e3 ("serial: Add driver for the
> > > Altera JTAG UART").
> > > 
> > > I have reverted those commits for today.
> > 
> > Those came in through the tty quilt tree, not the staging tree, right?
> 
> Yeah, I just don't do a build between merging the tty and staging trees.

Ok, that makes sense.

> > Tobias, care to send me a patch to resolve this?  I already fixed one
> > Kconfig issue in these patches (forcing the driver to always be built
> > in.)  Is that what caused this symbol issue?
> 
> I have reverted those commits again today.

I think I'll go drop these patches now.  Tobias, care to resend them
when you have them working properly?

thanks,

greg k-h
