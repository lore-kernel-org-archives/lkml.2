Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0HCM0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:26:53 -0400
Received: from mxout1.idt.com ([157.165.5.25]:35046 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab0HCM0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:26:52 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2010 08:26:52 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
Date: Tue, 3 Aug 2010 05:17:54 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520114309D@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4381.1280815590@neuling.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
Thread-Index: Acsy0pTOmhzzm4GETvS4r2R2pYb40wAMtx8w
References: <20100308191005.GE4324@amak.tundra.com> <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com> <AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com> <4381.1280815590@neuling.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Michael Neuling" <mikey@neuling.org>, "Timur Tabi" <timur.tabi@gmail.com>
Cc: "Alexandre Bounine" <abounine@tundra.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happened after change to book-e definitions.
There are patches that address this issue.

> -----Original Message-----
> From: Michael Neuling [mailto:mikey@neuling.org]
> Sent: Tuesday, August 03, 2010 2:07 AM
> To: Timur Tabi
> Cc: Alexandre Bounine; linuxppc-dev@lists.ozlabs.org;
linux-kernel@vger.kernel.org;
> thomas.moll@sysgo.com
> Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO
port
> 
> > > MCSR_MASK is not defined anywhere, so when I compile this code, I
get this:
> >
> > Never mind.  I see that it's been fixed already, and that the patch
> > that removed MCSR_MASK was posted around the same time that this
patch
> > was posted.
> 
> I don't know what happened here but 2.6.35 is broken because of this
> problem:
> 
> arch/powerpc/sysdev/fsl_rio.c:248: error: 'MCSR_MASK' undeclared
(first use in this function)
> arch/powerpc/sysdev/fsl_rio.c:248: error: (Each undeclared identifier
is reported only once
> arch/powerpc/sysdev/fsl_rio.c:248: error: for each function it appears
in.)
> arch/powerpc/sysdev/fsl_rio.c:250: error: 'MCSR_BUS_RBERR' undeclared
(first use in this function)
> 
> Mikey
