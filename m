Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab1ELSpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:45:04 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:54054 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754581Ab1ELSpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:45:02 -0400
Date: Thu, 12 May 2011 20:34:06 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] genalloc: add support to specify the physical
 address
Message-ID: <20110512183406.GI18952@game.jcrosoft.org>
References: <1303282455-26649-1-git-send-email-plagnioj@jcrosoft.com>
 <20110428081535.GI17290@n2100.arm.linux.org.uk>
 <20110512173832.GA8633@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512173832.GA8633@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3074269697644473267
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:38 Thu 12 May     , Russell King - ARM Linux wrote:
> On Thu, Apr 28, 2011 at 09:15:35AM +0100, Russell King - ARM Linux wrote:
> > On Wed, Apr 20, 2011 at 08:54:15AM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > so we specify the virtual address as base of the pool chunk and then
> > > get the physical address for hardware IP
> > > 
> > > as example on at91 we will use on spi, uart or macb
> > > 
> > > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > > Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> > > Hi Andrew,
> > > 	I integrate the documentation fix
> > > 	could replace the previous one with this one
> > > 
> > > V2:
> > > 	update documentation
> > > 	use phys_addr_t for physical addr
> > > Best Regards,
> > 
> > I notice no comments on this - maybe it needs to be Cc'd to linux-mm too?
> > 
> > Andrew - do you have any views on this?
> 
> Still haven't heard anything.  What's the status?
> 
> If this isn't going into mainline, I'll queue up my work consolidating
> the existing ARM sram allocators instead, and when this hits we can see
> about moving stuff over to it then.
Andrew - do you plan to add it for the -next?

I also need to implement at91 sram support for ethernet, spi and other drivers

and as Russell point other ARM need it also for consolidation.

And I'll not be able to use Russell's patch as I've to manage two sram in one
allocator on at91sam9263

Tks by advance
Best Regards,
J.
