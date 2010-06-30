Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0F3Ttp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:49:45 -0400
Received: from shutemov.name ([188.40.19.243]:46337 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab0F3Tto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:49:44 -0400
Date: Wed, 30 Jun 2010 22:49:42 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Christoph Egger <siccegge@cs.fau.de>,
       Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Russell King <linux@arm.linux.org.uk>,
       vamos@i4.informatik.uni-erlangen.de, Steve Chen <schen@mvista.com>,
       linux-kernel@vger.kernel.org, Sandeep Paulraj <s-paulraj@ti.com>,
       Cyril Chemparathy <cyril@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/33] Removing dead ARCH_DAVINCI_TNETV107X
Message-ID: <20100630194942.GB3969@shutemov.name>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <88ee583babc6f0aecb2238a57644f64159d5c395.1277911346.git.siccegge@cs.fau.de>
 <20100630170730.GE23534@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630170730.GE23534@tarshish>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 08:07:31PM +0300, Baruch Siach wrote:
> Hi Christoph,
> 
> On Wed, Jun 30, 2010 at 06:05:38PM +0200, Christoph Egger wrote:
> > ARCH_DAVINCI_TNETV107X doesn't exist in Kconfig, therefore removing
> > all references for it from the source code.
> > 
> > Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> > ---
> >  arch/arm/mach-davinci/include/mach/cputype.h |    6 ------
> >  1 files changed, 0 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm/mach-davinci/include/mach/cputype.h b/arch/arm/mach-davinci/include/mach/cputype.h
> > index cea6b89..6143022 100644
> > --- a/arch/arm/mach-davinci/include/mach/cputype.h
> > +++ b/arch/arm/mach-davinci/include/mach/cputype.h
> > @@ -85,10 +85,4 @@ IS_DAVINCI_CPU(tnetv107x, DAVINCI_CPU_ID_TNETV107X)
> >  #define cpu_is_davinci_da850() 0
> >  #endif
> >  
> > -#ifdef CONFIG_ARCH_DAVINCI_TNETV107X
> > -#define cpu_is_davinci_tnetv107x() is_davinci_tnetv107x()
> > -#else
> > -#define cpu_is_davinci_tnetv107x() 0
> 
> Why remove the #else part?

Nobody uses cpu_is_davinci_tnetv107x as well.

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
