Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0G1Hno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:43:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51864 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0G1Hnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:43:42 -0400
Date: Wed, 28 Jul 2010 08:43:22 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: linux-next: manual merge of the async_tx tree with the arm tree
Message-ID: <20100728074322.GA8147@flint.arm.linux.org.uk>
References: <20100727120805.f583c70b.sfr@canb.auug.org.au> <AANLkTin4EAQ48HP3ETDUMqBe2AzcznRuZdBdG+_RhR8x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin4EAQ48HP3ETDUMqBe2AzcznRuZdBdG+_RhR8x@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 12:11:19AM -0700, Dan Williams wrote:
> On Mon, Jul 26, 2010 at 7:08 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Dan,
> >
> > Today's linux-next merge of the async_tx tree got a conflict in
> > arch/arm/mach-ux500/devices-db8500.c between commit
> > 6055930cba8fdb2c8855b32bae262aaf69c1fdb4 ("ARM: 6266/1: ux500: add
> > separate irq lists for DB8500 and DB5500") from the arm tree and commit
> > 5aa12e8c9c57741606e52f43e62ab1b9dc8e9dcc ("DMAENGINE: ste_dma40: arch
> > updates for LCLA and LCPA") from the async_tx tree.
> >
> > I fixed it up (I think - see below) and can carry the fix as necessary.
> > --
> 
> Thanks Stephen!
> 
> Russell, the dma40 driver updates and related arch fixups have been
> sitting in next for a month, I'd prefer not to lose this baseline.
> Assuming this change is brand new any chance the dma40 specific part
> of this patch can be peeled off and sent through my tree, or are you
> in a similar "can't/won't" rebase position?

I don't see how the change in the ARM tree could be reasonably split.
Up to Rabin/Linus to decide what they want to do about this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
