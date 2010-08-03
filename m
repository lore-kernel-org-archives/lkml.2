Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0HCGGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 02:06:35 -0400
Received: from ozlabs.org ([203.10.76.45]:51158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab0HCGGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 02:06:33 -0400
From: Michael Neuling <mikey@neuling.org>
To: Timur Tabi <timur.tabi@gmail.com>
cc: Alexandre Bounine <abounine@tundra.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, thomas.moll@sysgo.com
Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
In-reply-to: <AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com>
References: <20100308191005.GE4324@amak.tundra.com> <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com> <AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com>
Comments: In-reply-to Timur Tabi <timur.tabi@gmail.com>
   message dated "Wed, 30 Jun 2010 16:00:56 -0500."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Tue, 03 Aug 2010 16:06:30 +1000
Message-ID: <4381.1280815590@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > MCSR_MASK is not defined anywhere, so when I compile this code, I get this:
> 
> Never mind.  I see that it's been fixed already, and that the patch
> that removed MCSR_MASK was posted around the same time that this patch
> was posted.

I don't know what happened here but 2.6.35 is broken because of this
problem:

arch/powerpc/sysdev/fsl_rio.c:248: error: 'MCSR_MASK' undeclared (first use in this function)
arch/powerpc/sysdev/fsl_rio.c:248: error: (Each undeclared identifier is reported only once
arch/powerpc/sysdev/fsl_rio.c:248: error: for each function it appears in.)
arch/powerpc/sysdev/fsl_rio.c:250: error: 'MCSR_BUS_RBERR' undeclared (first use in this function)

Mikey
