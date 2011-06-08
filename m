Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1FHFiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:38:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41625 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1FHFiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:38:03 -0400
From: Michael Neuling <mikey@neuling.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Eric Van Hensbergen <ericvh@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
Subject: Re: [PATCH] [RFC][V3] bluegene: add entry to cpu table
In-reply-to: <1307494181.2874.214.camel@pasglop>
References: <1307472447-1656-1-git-send-email-ericvh@gmail.com> <1307494181.2874.214.camel@pasglop>
Comments: In-reply-to Benjamin Herrenschmidt <benh@kernel.crashing.org>
   message dated "Wed, 08 Jun 2011 10:49:41 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Wed, 08 Jun 2011 15:37:58 +1000
Message-ID: <7945.1307511478@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Create an entry for the BG/P chips, include bits to accomodate
> > the double fp2 fpu and the special MMU considerations like L1
> > writethrough.
> > 
> > RFC Note: this patch fails scripts/checkpatch.pl because I
> > matched coding style of the surrounding existing code.  Would
> > you rather have something checkpatch.pl clean or something
> > which is consistent with the surrounding code style?
> 
> Stay consistent. You're welcome to my next checkpatch burning
> ceremony :-)

I'll make t-shirts for us!

> >  #define PPC_FEATURE_POWER6_EXT		0x00000200
> >  #define PPC_FEATURE_ARCH_2_06		0x00000100
> >  #define PPC_FEATURE_HAS_VSX		0x00000080
> > +#define PPC_FEATURE_HAS_FPU_FP2		0x00000040
> 
> Any chance for a better name ?

I've painted this particular bike shed with Eric already :-)

It's an extension to the FPU called FP2
(https://wiki.alcf.anl.gov/images/d/d9/PPC440_FP2_arch.pdf).  
So PPC_FEATURE_HAS_FPU -> PPC_FEATURE_HAS_FPU_FP2.

I think the name is right as he has it.

Mikey
