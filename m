Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1E3UXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:23:51 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:48398 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1E3UXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:23:50 -0400
Date: Mon, 30 May 2011 14:23:47 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Barry Song <21cnbao@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Xilinx: Adding zynq platform support
Message-ID: <20110530202347.GC32035@ponder.secretlab.ca>
References: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com>
 <alpine.LFD.2.00.1105241435550.3207@xanadu.home>
 <BANLkTi=hCpCbNzi1ZiKmGnbhmCG2Ce=EkA@mail.gmail.com>
 <201105261559.41993.arnd@arndb.de>
 <BANLkTikjMYUCXgBN3UKjpzEg68qOqOHv5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikjMYUCXgBN3UKjpzEg68qOqOHv5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 05:47:35PM +0800, Barry Song wrote:
> 2011/5/26 Arnd Bergmann <arnd@arndb.de>:
> > On Wednesday 25 May 2011, Grant Likely wrote:
> >>
> >> As per discussion attached below.  Please pull this tree adding device
> >> tree support to ARM, plus some other minor device tree changes.
> >
> > Hi Grant and Linus,
> >
> > There is also the new Xilinx zynq subarchitecture pending that depends
> > on this, see below. Should we also include that right away, in order
> > to have an example for other platforms? I think the code is clean
> > enough and it would be good to have.
> >
> >        Arnd
> >
> > 8<---------
> > From: Grant Likely <grant.likely@secretlab.ca>
> >
> > The 1st board support is minimal to get a system up and running
> > on the Xilinx platform.
> >
> > This platform reuses the clock implementation from plat-versatile, and
> > it depends entirely on CONFIG_OF support.  There is only one board
> > support file which obtains all device information from a device tree
> > dtb file which is passed to the kernel at boot time.
> >
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > [john.linn@xilinx.com: Reverted dependency on of_irq_domain patches]
> > Signed-off-by: John Linn <john.linn@xilinx.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> is there a whole complete tree for zynq? i'd like to refer. thanks! as
> i am moving csr prima2 to device tree, we need to change so many
> codes. i hope we can follow what the way zynq is doing.

It is in linux-next.  Hopefully we'll get it merged into the arm
subarch maintainer tree early in this cycle.

You can also look at arch/powerpc/platforms/* to see examples of how
to work with the DT.  I'm also working on some howto documentation for
doing DT work.

g.

