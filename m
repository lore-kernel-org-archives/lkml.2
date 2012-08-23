Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622Ab2HWQDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:03:04 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:48113 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030572Ab2HWQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:03:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACFTNlDCTtAn/2dsb2JhbABFulGBB4IgAQEFOj8QCxguFBgxE4gRug+LCIYxYAOVUwGQFIJl
Date: Thu, 23 Aug 2012 18:02:55 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support to broadcom 5222 PHY
Message-ID: <20120823160255.GA32671@frolo.macqel>
References: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com> <CAMuHMdUo5UPLtUhf6_GafMj_kEnM25k+XYszdwsGwkGyCUC6zw@mail.gmail.com> <CA+mBkFXnOB9hPoJVf6c92UuemqtLJwc2KW-G-ja6cG8VqLPZdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+mBkFXnOB9hPoJVf6c92UuemqtLJwc2KW-G-ja6cG8VqLPZdw@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:21:23PM +0200, Stany MARCEL wrote:
> On Thu, Aug 23, 2012 at 12:47 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Tue, Aug 21, 2012 at 2:18 PM, Stany MARCEL
> > <stany.marcel@novasys-ingenierie.com> wrote:
> >> Signed-off-by: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
> >> ---
> >>
> >>  This driver is an adaption of the one given by freescale for kernel 2.6.25.
> >>
> >>  Tested with kernel 3.4.8 with arch/m68k backported from linux-m68k head
> >>  2 FEC configured with shared phy
> >>
> >>  drivers/net/phy/Kconfig        |    7 +-
> >>  drivers/net/phy/Makefile       |    1 +
> >>  drivers/net/phy/broadcom522x.c |  171 ++++++++++++++++++++++++++++++++++++++++
> >
> > This patch and "[PATCH 3/3] Add support to M54xx DMA FEC Driver" need to go
> > through the netdev tree, or collect acks there.
> >
> > Gr{oetje,eeting}s,
> >
> >                         Geert
> >
> 
> Hello Geert,
> 
> Please, what is the good process to follow as patch 3 depends on patch 1 ?

Actually, IMHO patch 3 does not depend on patch 1, and I even think that
patch 1 is not needed, except to get a message with "BCM5222" instead
of "Generic PHY" in the kernel log.

AFAIK the phy interface is standardized.

Philippe
