Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1DKV0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:26:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:57110 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1DKV0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:26:07 -0400
Subject: Re: [PATCH 3/6] microblaze/pci: Move the remains of pci_32.c to
 pci-common.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, bheglaas@google.com,
        monstr@monstr.eu, tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <da7a8b1fa75c0968a4586a591713d5db.squirrel@webmail.sf-mail.de>
References: <1302495170-973-1-git-send-email-benh@kernel.crashing.org>
	 <1302495170-973-4-git-send-email-benh@kernel.crashing.org>
	 <da7a8b1fa75c0968a4586a591713d5db.squirrel@webmail.sf-mail.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 07:25:33 +1000
Message-ID: <1302557133.28876.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 15:12 +0000, Rolf Eike Beer wrote:
> > There's no point in keeping this separate. Even if microblaze grows
> > a 64-bit variant, it will probably be able to re-use that code as-is
> 
> > diff --git a/arch/microblaze/pci/pci-common.c
> > b/arch/microblaze/pci/pci-common.c
> > index 5359906..041b1d8 100644
> > --- a/arch/microblaze/pci/pci-common.c
> > +++ b/arch/microblaze/pci/pci-common.c
> > @@ -50,6 +50,11 @@ unsigned int pci_flags;
> >
> >  static struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
> >
> > +unsigned long isa_io_base;
> > +unsigned long pci_dram_offset;
> > +static int pci_bus_count;
> > +
> > +
> 
> Extra newline.

Can people with no useful content abstain from commenting please.

Cheers,
Ben.


