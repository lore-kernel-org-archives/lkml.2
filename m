Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370Ab1KJQzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:55:04 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:21285
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965350Ab1KJQzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:55:00 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Thu, 10 Nov 2011 10:54:55 -0600
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Message-ID: <20111110165455.GE11983@schlenkerla.am.freescale.net>
References: <4E42AB6F.1050900@freescale.com>
 <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
 <C0DED343-76A8-457E-BF54-E52DFCAC83A8@boeing.com>
 <58FDDDA5-26C4-493B-A00D-81DD94A5C26A@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <58FDDDA5-26C4-493B-A00D-81DD94A5C26A@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:30:41AM -0600, Kumar Gala wrote:
> On Nov 10, 2011, at 10:17 AM, Moffett, Kyle D wrote:
> > Furthermore, it looks like there are a couple issues here I missed
> > before.  PPC64 systems all appear to have an L1_CACHE_SHIFT of 7,
> > except when you turn on the P5020DS board option which magically
> > changes it to "6" and breaks lord-knows-what.  I think my patch
> > series actually "breaks" that and makes e5500 use 7 as well.
> 
> a value of '6' on E5500 / P5020DS is correct and doesn't break anything.  Setting it to 7 is wrong and thus the code is correct today.
> 
> > Are you sure that a kernel built to support E5500 can also run on
> > other 64-bit PowerPC/POWER systems?
> 
> No it will not.  There is not expectation of that as E5500 is an
> embedded / Book-E class part and uses that ISA version.  Book-S
> (server) 64-bit machines are not OS compatible and we are not trying to
> make them as such (but we do re-use a lot of code).

What about other 64-bit book3e chips?  What cache block size does A2 have?

-Scott

