Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0LCAOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:14:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757824Ab0LCAOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:14:33 -0500
Date: Thu, 2 Dec 2010 16:14:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Struk, Tadeusz" <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Message-Id: <20101202161403.74daae6f.akpm@linux-foundation.org>
In-Reply-To: <24483BA4C9F69C43A7379639D35543D7C3450A84@irsmsx502.ger.corp.intel.com>
References: <4CC9946D.mailLH511GU0C@intel.com>
	<20101104190405.GA2501@gondor.apana.org.au>
	<20101117172331.3bbec734.akpm@linux-foundation.org>
	<20101118092640.GA9486@gondor.apana.org.au>
	<24483BA4C9F69C43A7379639D35543D7C3450A84@irsmsx502.ger.corp.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 09:38:50 +0000
"Struk, Tadeusz" <tadeusz.struk@intel.com> wrote:

> -----Original Message-----
> > From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
> > Sent: Thursday, November 18, 2010 9:27 AM
> > To: Andrew Morton
> > Cc: Struk, Tadeusz; linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org; O Mahony, Aidan; Paoloni, Gabriele; Hoban, Adrian
> > Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
> > 
> > On Wed, Nov 17, 2010 at 05:23:31PM -0800, Andrew Morton wrote:
> > > On Thu, 4 Nov 2010 14:04:05 -0500
> > > Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> > > 
> > > > On Thu, Oct 28, 2010 at 04:19:09PM +0100, tadeusz.struk@intel.com wrote:
> > > > > Hi Herbert,
> > > > >    We have reworked the assembly to use macros instead of the new aesni instructions.
> > > > 
> > > > Both applied.  Thanks for your efforts!
> > > 
> > > Whatever's in today's linux-next is a big fail with gas-2.16.1.
> > > 
> > > Which was entirely predictable!  How often has this happened recently??
> > > 
> > > 
> > > arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> > > arch/x86/crypto/aesni-intel_asm.S:834: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm13'
> > > arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm5'
> > > arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
> > > arch/x86/crypto/aesni-intel_asm.S:866: Error: bad expression
> > 
> > Sorry, but I no longer have access to a binutils that is older
> > than 2.18 so I never saw this failure.
> > 
> > Tadeusz, could you please make an incremental patch that converts
> > all the pshufb instructions to macros?
> > 
>
> Will do.
> Tadeusz
> 

(top-posting repaired)

(busted attribution/quoting repaired)

Current mainline still has this failure.
