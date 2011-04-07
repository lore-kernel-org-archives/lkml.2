Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1DGWbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:31:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:52217 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab1DGWbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:31:07 -0400
Subject: Re: [PATCHES] Generalize PCI <-> OF node matching
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
In-Reply-To: <20110407.151636.183068185.davem@davemloft.net>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
	 <20110407.151636.183068185.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 08:30:55 +1000
Message-ID: <1302215455.2458.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 15:16 -0700, David Miller wrote:
> > This series generalize the PCI <-> OF node matching, moves it to the
> > PCI core and make our archs use it. I also rip out while at it a whole
> > bunch of useless stuff from microblaze PCI code which was copied from
> > ppc32 and is essentially useless there (old workarounds for PowerMac
> > and ancient X servers).
> > 
> > Compile tested on x86_64, microblaze, sparc64 and powerpc.
> 
> What tree is this against?  None of the microblaze and x86 bits
> apply without rejects against Linus's tree, which is where I'm
> trying to test this.
> 
> I'll trudge through it, but a heads up about what your patches
> are against in the future would be heavily appreciated. 

Sorry about that, it's Linus as of 3 days ago or so, commit
44148a667d3715f3a1c37eeff7e954c946cc1efe.

I'm surprised it would have changed that significantly since then but
I'll check & fixup, I can send a new one later today. I'll make sure to
specify the "anchor" commit next time.

Cheers,
Ben.


