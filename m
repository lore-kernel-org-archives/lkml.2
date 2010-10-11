Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0JKGu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 02:50:27 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44537 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab0JKGu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 02:50:26 -0400
Date: Sun, 10 Oct 2010 23:50:15 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/7] sparc: make drivers/of/pdt.c no longer sparc-only
Message-ID: <20101010235015.2954811f@uxo>
In-Reply-To: <20101011040443.GA23588@angua.secretlab.ca>
References: <20101010014358.30cb74b5@debxo>
	<20101010020905.1e27c1b4@debxo>
	<20101011040443.GA23588@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010 22:04:43 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Sun, Oct 10, 2010 at 02:09:05AM -0700, Andres Salomon wrote:
> > Whoops, that should've been 1/5, not 1/7.  Two additional x86
> > patches snuck in there that are already in Grant's test-devicetree
> > branch.
> 
> Note that of the two patches I'm carrying in test-devicetree, only one
> of them is actually able to move into linux-next at this present time.
> 
> 1) of/irq: remove references to NO_IRQ in drivers/of/platform.c
> 
> I'm putting this one into next-devicetree now
> 
> 2) x86/of: define irq functions to allow drivers/of/* to build on x86
> 
> I've not yet received an ack from the x86 maintainers on this, so I
> cannot put it into my next branch.  (Sorry I didn't notice this
> earlier; it just dawned on me as I was looking over which patches I
> needed to move over).  The same goes for the patch that actaully adds
> OF support for x86 OLPC.  I'll need an ack from x86 folks before I
> merge it.
> 
> g.

Okay.  For reference, that patch is:

https://patchwork.kernel.org/patch/168662/

x86 folks, mind reviewing and providing an Ack or Nack?
