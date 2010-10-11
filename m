Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750869Ab0JKEEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 00:04:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43483 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab0JKEEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 00:04:46 -0400
Date: Sun, 10 Oct 2010 22:04:43 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] sparc: make drivers/of/pdt.c no longer sparc-only
Message-ID: <20101011040443.GA23588@angua.secretlab.ca>
References: <20101010014358.30cb74b5@debxo>
 <20101010020905.1e27c1b4@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010020905.1e27c1b4@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 02:09:05AM -0700, Andres Salomon wrote:
> Whoops, that should've been 1/5, not 1/7.  Two additional x86 patches
> snuck in there that are already in Grant's test-devicetree branch.

Note that of the two patches I'm carrying in test-devicetree, only one
of them is actually able to move into linux-next at this present time.

1) of/irq: remove references to NO_IRQ in drivers/of/platform.c

I'm putting this one into next-devicetree now

2) x86/of: define irq functions to allow drivers/of/* to build on x86

I've not yet received an ack from the x86 maintainers on this, so I
cannot put it into my next branch.  (Sorry I didn't notice this
earlier; it just dawned on me as I was looking over which patches I
needed to move over).  The same goes for the patch that actaully adds
OF support for x86 OLPC.  I'll need an ack from x86 folks before I
merge it.

g.


> 
> 
> On Sun, 10 Oct 2010 01:43:58
> -0700 Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > Clean up pdt.c:
> >  - make build dependent upon config OF_PROMTREE
> >  - #ifdef out the sparc-specific stuff
> >  - create pdt-specific header
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
