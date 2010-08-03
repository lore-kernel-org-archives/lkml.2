Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0HCNZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:25:09 -0400
Received: from mxout1.idt.com ([157.165.5.25]:36713 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab0HCNZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:25:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
Date: Tue, 3 Aug 2010 06:24:47 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011430BC@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <AANLkTinpwYnyc1oN1VbtBgUF6bk6E5q_Gq1Dj3WXV3wc@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
Thread-Index: AcszC8UElBYHaZlHSsmvZEE2KBL+0wAAhg7A
References: <20100308191005.GE4324@amak.tundra.com> <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com> <AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com> <4381.1280815590@neuling.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520114309D@CORPEXCH1.na.ads.idt.com> <AANLkTinpwYnyc1oN1VbtBgUF6bk6E5q_Gq1Dj3WXV3wc@mail.gmail.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Timur Tabi" <timur@freescale.com>
Cc: "Michael Neuling" <mikey@neuling.org>,
        "Alexandre Bounine" <abounine@tundra.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <thomas.moll@sysgo.com>, "Kumar Gala" <galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yang Li pointed to these patches in his post from July 23, 2010.
It would be nice to have these patches in mainline code. 

> -----Original Message-----
> From: timur.tabi@gmail.com [mailto:timur.tabi@gmail.com] On Behalf Of
Timur Tabi
> Sent: Tuesday, August 03, 2010 9:02 AM
> To: Bounine, Alexandre
> Cc: Michael Neuling; Alexandre Bounine; linuxppc-dev@lists.ozlabs.org;
linux-kernel@vger.kernel.org;
> thomas.moll@sysgo.com; Kumar Gala
> Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO
port
> 
> On Tue, Aug 3, 2010 at 7:17 AM, Bounine, Alexandre
> <Alexandre.Bounine@idt.com> wrote:
> > This happened after change to book-e definitions.
> > There are patches that address this issue.
> 
> And those patches should have been applied before 2.6.35 was released.
>  Someone dropped the ball.  2.6.35 is broken for a number of PowerPC
> boards:
> 
> $ make mpc85xx_defconfig
> ....
> $ make
> ....
>   CC      arch/powerpc/sysdev/fsl_rio.o
> arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
> arch/powerpc/sysdev/fsl_rio.c:248: error: 'MCSR_MASK' undeclared
> (first use in this function)
> arch/powerpc/sysdev/fsl_rio.c:248: error: (Each undeclared identifier
> is reported only once
> arch/powerpc/sysdev/fsl_rio.c:248: error: for each function it appears
in.)
> make[1]: *** [arch/powerpc/sysdev/fsl_rio.o] Error 1
> 
> --
> Timur Tabi
> Linux kernel developer at Freescale
