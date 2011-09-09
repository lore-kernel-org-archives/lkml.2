Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab1IIQSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:18:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:37418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab1IIQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:18:44 -0400
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vkoul@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vinod.koul@intel.com, Linus Walleij <linus.walleij@linaro.org>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        Barry Song <Baohua.Song@csr.com>, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <2264116.VTHb2BIH5a@wuerfel>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	 <201109081819.30035.arnd@arndb.de>
	 <CAKnu2Mpnjec-hvfbT0zH1P2mGZKNwTQYgDLGHWUXLmGGQB0_ow@mail.gmail.com>
	 <2264116.VTHb2BIH5a@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Fri, 09 Sep 2011 21:40:59 +0530
Message-ID: <1315584659.28058.5.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 22:11 +0200, Arnd Bergmann wrote:
> On Thursday 08 September 2011 20:48:26 Linus Walleij wrote:
> > 2011/9/8 Arnd Bergmann <arnd@arndb.de>:
> > > On Thursday 08 September 2011, Barry Song wrote:
> > >>
> > >> this filter is used by all drivers with DMA since every dma channel is
> > >> fixed to be assigned to one device.
> > >
> > > Ok, I see now. I think it would be best to introduce a generic
> > > 'filter by device tree property' function or alternatively an
> > > dma_of_request_channel function like this:
> > 
> > You'd have to discuss that with Vinod, the thing is that x86 Atom
> > systems are using dmaengine for device slave transfers too, and
> > IIRC these things don't use devicetrees. I may be wrong...
> 
> Some of them use device tree, some don't.
> 
> I'm not saying that we have to convert all drivers to use this, but
> for platforms that always have device tree available, it seems by far
> the cleanest solution.
It maybe a clean solution but if it doesn't fit all needs, then it am
not sure...

One way as I said earlier to get the information of dmac-client
relationships from arch specific way (pci, device tree etc) and
dmacs/clients/platform presents them in arch-independent way to
dmaengine...

Thoughts?

--
~Vinod

-- 
~Vinod Koul
Intel Corp.

