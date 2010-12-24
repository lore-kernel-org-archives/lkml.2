Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0LXA4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 19:56:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:50778 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab0LXA4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 19:56:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,221,1291622400"; 
   d="scan'208";a="586817916"
Subject: Re: [RFC -v9 1/4] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
From: Huang Ying <ying.huang@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "rth@twiddle.net" <rth@twiddle.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "starvik@axis.com" <starvik@axis.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "ysato@users.sourceforge.jp" <ysato@users.sourceforge.jp>,
        "Luck, Tony" <tony.luck@intel.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "liqin.chen@sunplusct.com" <liqin.chen@sunplusct.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "chris@zankel.net" <chris@zankel.net>
In-Reply-To: <20101223.093544.71126698.davem@davemloft.net>
References: <1293083003-19577-1-git-send-email-ying.huang@intel.com>
	 <1293083003-19577-2-git-send-email-ying.huang@intel.com>
	 <20101223.093544.71126698.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Dec 2010 08:56:45 +0800
Message-ID: <1293152205.22308.26.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David,

Thanks for review.

On Fri, 2010-12-24 at 01:35 +0800, David Miller wrote:
> From: Huang Ying <ying.huang@intel.com>
> Date: Thu, 23 Dec 2010 13:43:20 +0800
> 
> > --- a/arch/sparc/Kconfig
> > +++ b/arch/sparc/Kconfig
> > @@ -22,6 +22,7 @@ config SPARC
> >  	select RTC_CLASS
> >  	select RTC_DRV_M48T59
> >  	select HAVE_IRQ_WORK
> > +	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> >  	select HAVE_DMA_ATTRS
> >  	select HAVE_DMA_API_DEBUG
> >  	select HAVE_ARCH_JUMP_LABEL
> 
> This should only be set for "SPARC64".  SPARC32's cmpxchg uses spinlocks and
> IRQ disabling, which is not NMI safe.

I will fix this.

Best Regards,
Huang Ying


