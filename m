Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024Ab1D2WwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:52:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:41351 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab1D2WwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:52:15 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110429125613.616f977b@lxorguk.ukuu.org.uk>
References: <201104212129.17013.arnd@arndb.de>
	 <20110428093039.GU17290@n2100.arm.linux.org.uk>
	 <1304024836.2513.198.camel@pasglop> <201104291326.25634.arnd@arndb.de>
	 <20110429125613.616f977b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 08:51:54 +1000
Message-ID: <1304117514.2513.266.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 12:56 +0100, Alan Cox wrote:
> > I believe that the PC graphics cards that have noncoherent DMA mappings
> > are all of the unified memory (integrated into the northbridge) kind,
> > so they are not on the same host bridge as all regular PCI devices,
> > even if they appear as a PCI device.
> 
> The AGP GART is not coherent on a lot of systems - not necessarily
> unified memory though, it can be a plug in AGP card too.
> The GART is basically an IOMMU (and indeed in the later AMD case used
> exactly as that)

Right. Actually there's also the ability for PCIe devices to set a "no
snoop" bit on transactions and thus behave in a non-coherent manner.
Hopefully most sane PHBs ignore that bit ...

Cheers,
Ben.

