Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0EAPmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 11:42:45 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:47994 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab0EAPmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 11:42:44 -0400
Date: Sat, 1 May 2010 17:42:42 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20100501154242.GV9489@distanz.ch>
References: <20100427141224.834a102a.sfr@canb.auug.org.au> <20100427151305.GA7653@kroah.com> <20100428161425.eff4c40a.sfr@canb.auug.org.au> <20100428152809.GF4483@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428152809.GF4483@kroah.com>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-04-28 at 17:28:09 +0200, Greg KH <greg@kroah.com> wrote:
> On Wed, Apr 28, 2010 at 04:14:25PM +1000, Stephen Rothwell wrote:
> > On Tue, 27 Apr 2010 08:13:05 -0700 Greg KH <greg@kroah.com> wrote:
> > >
> > > On Tue, Apr 27, 2010 at 02:12:24PM +1000, Stephen Rothwell wrote:
> > > > 
> > > > After merging the staging tree, today's linux-next build (x86_64
> > > > allmodconfig) failed like this:
> > > > 
> > > > ERROR: "uart_console_device" [drivers/serial/altera_uart.ko] undefined!
> > > > ERROR: "uart_console_device" [drivers/serial/altera_jtaguart.ko] undefined!
> > > > 
> > > > Introduced by commits 76bdbd933febe791fee114e7bb6c42bbd1a3f4f3 ("serial:
> > > > Add driver for the Altera UART") and
> > > > 11c59b34b299d7214b466cf799410a9a540476e3 ("serial: Add driver for the
> > > > Altera JTAG UART").
> > > > 
> > > > I have reverted those commits for today.
> > > 
> > > Those came in through the tty quilt tree, not the staging tree, right?
> > 
> > Yeah, I just don't do a build between merging the tty and staging trees.
> 
> Ok, that makes sense.
> 
> > > Tobias, care to send me a patch to resolve this?  I already fixed one
> > > Kconfig issue in these patches (forcing the driver to always be built
> > > in.)  Is that what caused this symbol issue?
> > 
> > I have reverted those commits again today.
> 
> I think I'll go drop these patches now.  Tobias, care to resend them
> when you have them working properly?

Yepp, I'll have a look at it and will send the updated patches as soon
as I resolved it.

Thanks
Tobias
