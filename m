Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1FENIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 09:08:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58667 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab1FENIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 09:08:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 5 Jun 2011 15:08:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Baruch Siach <baruch@tkos.co.il>, Grant Likely <grant.likely@secretlab.ca>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: reorganize drivers
Message-ID: <20110605150807.0cb01ba0@stein>
In-Reply-To: <BANLkTi=5XLxcZiBcZT8W4Gh+Ph_BUjs-yw@mail.gmail.com>
References: <20110605071725.26517.11573.stgit@ponder>
	<BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
	<20110605075458.GA2712@tarshish>
	<BANLkTi=5XLxcZiBcZT8W4Gh+Ph_BUjs-yw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 05 Geert Uytterhoeven wrote:
> On Sun, Jun 5, 2011 at 09:54, Baruch Siach <baruch@tkos.co.il> wrote:
> > On Sun, Jun 05, 2011 at 01:13:28PM +0530, Jassi Brar wrote:
> >> On Sun, Jun 5, 2011 at 12:48 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> >> > [repost: I had a typo on the spi-devel-general mailing list address]
> >> >
> >> > Sort the SPI makefile and enforce the naming convention spi_*.c for
> >> > spi drivers.
> >
> > [snip]
> >
> >> Though the spi_ prefix seems redundant considering the files are in
> >> 'spi' directory.
> >> Just a thought, no objection.
> >
> > When looking at the list of loaded modules (e.g. in an Oops message), the name
> > "spi_xilinx" is much more meaningful than just "xilinx", for example.
> 
> Plus, when dropping the prefix, spi_xilinx.ko and gpio-xilinx.ko
> become the same...

In drivers/firewire/Makefile for example, there is this:

	firewire-core-y += core-card.o core-cdev.o core-device.o \
	                   core-iso.o core-topology.o core-transaction.o
	firewire-ohci-y += ohci.o
	firewire-sbp2-y += sbp2.o
	firewire-net-y  += net.o

Which is impractical though if there are more than a handful of drivers
involved.
-- 
Stefan Richter
-=====-==-== -==- --=-=
http://arcgraph.de/sr/
