Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0K0MYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 07:24:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50556 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0K0MYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 07:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=RaB5se+PG2fWZV9OqFxierJHn3U+Z6eAdWXIUynr65B6h1oeu6jbePYBbnHAhjGcFi
         SEQN1ULPiezhv4ApRXiG2H9+G0eeL0Mc6lE9jrnpXxZqZhgVQUiwYj3uUa5havyWt1TI
         SwFHUzAb3mi+b3MzQEGba8kkLgCELu9fbrAV8=
Date: Sat, 27 Nov 2010 13:16:24 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
X-X-Sender: elektroman@localhost.localdomain
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
In-Reply-To: <AANLkTikkVqWgpYEg505DwQ+pSegQv1g-Q8cDEpE-JCrV@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1011271306420.7659@localhost.localdomain>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <AANLkTikkVqWgpYEg505DwQ+pSegQv1g-Q8cDEpE-JCrV@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1840345849-1290860228=:7659"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1840345849-1290860228=:7659
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT



On Fri, 26 Nov 2010, Micha³ Miros³aw wrote:

> 2010/11/20 Hans Ulli Kroll <ulli.kroll@googlemail.com>:
> > Add support for PCI Bus on Gemini Devices SL3516
> >
> > Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> > ---
> [...]
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index a19a526..5d4b398 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -307,6 +307,7 @@ config ARCH_GEMINI
> >        select CPU_FA526
> >        select ARCH_REQUIRE_GPIOLIB
> >        select ARCH_USES_GETTIMEOFFSET
> > +       select PCI
> >        help
> >          Support for the Cortina Systems Gemini family SoCs
> >
> [...]
> 
> I think it's better to add ARCH_GEMINI to CONFIG_PCI dependencies.
> AFAIK IB-4220B NAS does not use PCI and doesn't need all that code.
> Board support entries could select PCI if the board is useless without
> it.
> 

I know this, I have some.

There are many boards with PCI i.e WBD 222.
Other ARM devices uses the same select inside ARCH_*
I don't want to pollute drivers/pci/Kconfig.

Ulli
--8323328-1840345849-1290860228=:7659--
