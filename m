Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab0K2INL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:13:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48154 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0K2INJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=eRK2CS0W7u/WArfLY4MOMeMJFs9VuN0tpCw9UAwKj6YC2emhirTL400rGiVgxmrPRF
         kgTjZbZro+VDOHHOOi/MpUwLvpstVMCRKK1MEZy+FRUDY8R5uEkUK4eFIPX/P3g3TWBG
         qoossTLFND2r1pCttL9fb0FqRSFF8jdpCjt2g=
Date: Mon, 29 Nov 2010 09:12:51 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
X-X-Sender: elektroman@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
In-Reply-To: <201011271639.21694.arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1011290912270.10937@localhost.localdomain>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <alpine.LNX.2.00.1011271306420.7659@localhost.localdomain> <AANLkTinbAVFE+HZrx+9KUwx8=MKFHPqrhpOpAWAEQFv-@mail.gmail.com> <201011271639.21694.arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2113523565-1291018387=:10937"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2113523565-1291018387=:10937
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT



On Sat, 27 Nov 2010, Arnd Bergmann wrote:

> On Saturday 27 November 2010 14:01:20 Micha³ Miros³aw wrote:
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index db524e7..74ea522 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1164,7 +1164,7 @@ config ISA_DMA_API
> >         bool
> > 
> >  config PCI
> > -       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB ||
> > ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
> > +       bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB ||
> > ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX ||
> > ARCH_GEMINI
> >         help
> >           Find out whether you have a PCI motherboard. PCI is the name of a
> >           bus system, i.e. the way the CPU talks to the other stuff inside
> > 
> 
> This approach really does not scale as we add more boards to the list.
> 
> Better make a new CONFIG_HAVE_PCI option that you can select from the
> individual boards, and make that the only dependency that CONFIG_PCI has.
> 
> 	Arnd
> 
Good idea.
I write a patch for this.

Ulli
--8323328-2113523565-1291018387=:10937--
