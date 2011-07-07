Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab1GGTHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:07:53 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:43612 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1GGTHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:07:52 -0400
Subject: Re: Build issue with linux next. duplicate member _count in
 mm_types.h
From: Pekka Enberg <penberg@kernel.org>
To: piotr@hosowicz.com
Cc: Christoph Lameter <cl@linux.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <4E15B945.5060805@example.com>
References: <4E143120.2020501@cam.ac.uk>
	 <alpine.DEB.2.00.1107060933460.17202@router.home>
	 <4E15AF1C.7080103@example.com>
	 <alpine.DEB.2.00.1107070841500.17376@router.home>
	 <4E15B945.5060805@example.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 07 Jul 2011 22:07:50 +0300
Message-ID: <1310065670.21902.62.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 15:48 +0200, Piotr Hosowicz wrote:
> On 07.07.2011 15:42, Christoph Lameter wrote:
> > On Thu, 7 Jul 2011, Piotr Hosowicz wrote:
> >
> >> On 06.07.2011 16:46, Christoph Lameter wrote:
> >>> On Wed, 6 Jul 2011, Jonathan Cameron wrote:
> >>>
> >>>> Getting:
> >>>>
> >>>>     CHK     include/linux/version.h
> >>>>     CHK     include/generated/utsrelease.h
> >>>> make[1]: `include/generated/mach-types.h' is up to date.
> >>>>     CC      arch/arm/kernel/asm-offsets.s
> >>>> In file included from include/linux/sched.h:64:0,
> >>>>                    from arch/arm/kernel/asm-offsets.c:13:
> >>>> include/linux/mm_types.h:74:15: error: duplicate member '_count'
> >>>> make[1]: *** [arch/arm/kernel/asm-offsets.s] Error 1
> >>>> make: *** [prepare0] Error 2
> >>
> >> I have the same error on x86_64. I'll try again withj your patch.
> >
> > Could you post a config file?
> 
> I attach it. Your patch seems to had worked, I finish making the package.

I'm confused. Does Christoph's patch fix the problem for everyone?

			Pekka

