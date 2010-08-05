Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab0HEDeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:34:23 -0400
Received: from ozlabs.org ([203.10.76.45]:40810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704Ab0HEDeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:34:21 -0400
From: Michael Neuling <mikey@neuling.org>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
cc: "Timur Tabi" <timur@freescale.com>,
        "Alexandre Bounine" <abounine@tundra.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        thomas.moll@sysgo.com, "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
In-reply-to: <0CE8B6BE3C4AD74AB97D9D29BD24E552011430BC@CORPEXCH1.na.ads.idt.com>
References: <20100308191005.GE4324@amak.tundra.com> <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com> <AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com> <4381.1280815590@neuling.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520114309D@CORPEXCH1.na.ads.idt.com> <AANLkTinpwYnyc1oN1VbtBgUF6bk6E5q_Gq1Dj3WXV3wc@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552011430BC@CORPEXCH1.na.ads.idt.com>
Comments: In-reply-to "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
   message dated "Tue, 03 Aug 2010 06:24:47 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 05 Aug 2010 13:34:20 +1000
Message-ID: <26581.1280979260@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <0CE8B6BE3C4AD74AB97D9D29BD24E552011430BC@CORPEXCH1.na.ads.idt.com> you wrote:
> Yang Li pointed to these patches in his post from July 23, 2010.
> It would be nice to have these patches in mainline code.=20

This is still broken in Kumar's latest tree.  Do you guys wanna repost
them so Kumar can pick them up easily?

Mikey

> 
> > -----Original Message-----
> > From: timur.tabi@gmail.com [mailto:timur.tabi@gmail.com] On Behalf Of
> Timur Tabi
> > Sent: Tuesday, August 03, 2010 9:02 AM
> > To: Bounine, Alexandre
> > Cc: Michael Neuling; Alexandre Bounine; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org;
> > thomas.moll@sysgo.com; Kumar Gala
> > Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO
> port
> >=20
> > On Tue, Aug 3, 2010 at 7:17 AM, Bounine, Alexandre
> > <Alexandre.Bounine@idt.com> wrote:
> > > This happened after change to book-e definitions.
> > > There are patches that address this issue.
> >=20
> > And those patches should have been applied before 2.6.35 was released.
> >  Someone dropped the ball.  2.6.35 is broken for a number of PowerPC
> > boards:
> >=20
> > $ make mpc85xx_defconfig
> > ....
> > $ make
> > ....
> >   CC      arch/powerpc/sysdev/fsl_rio.o
> > arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
> > arch/powerpc/sysdev/fsl_rio.c:248: error: 'MCSR_MASK' undeclared
> > (first use in this function)
> > arch/powerpc/sysdev/fsl_rio.c:248: error: (Each undeclared identifier
> > is reported only once
> > arch/powerpc/sysdev/fsl_rio.c:248: error: for each function it appears
> in.)
> > make[1]: *** [arch/powerpc/sysdev/fsl_rio.o] Error 1
> >=20
> > --
> > Timur Tabi
> > Linux kernel developer at Freescale
> 
