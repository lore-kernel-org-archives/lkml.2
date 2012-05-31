Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2EaMua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:50:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65448 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2EaMu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:50:26 -0400
Date: Thu, 31 May 2012 20:50:12 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] ARM: cmpxchg: define __HAVE_ARCH_CMPXCHG for armv6
 and later
Message-ID: <20120531125012.GA3741@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1338364287-11614-1-git-send-email-yong.zhang0@gmail.com>
 <20120531012450.GA8506@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120531012450.GA8506@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 02:24:50AM +0100, Will Deacon wrote:
> Hello,
> 
> On Wed, May 30, 2012 at 08:51:26AM +0100, Yong Zhang wrote:
> > diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
> > index 7eb18c1..a91b44e 100644
> > --- a/arch/arm/include/asm/cmpxchg.h
> > +++ b/arch/arm/include/asm/cmpxchg.h
> > @@ -127,6 +127,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> >  
> >  #else	/* min ARCH >= ARMv6 */
> >  
> > +#define __HAVE_ARCH_CMPXCHG 1
> > +
> >  extern void __bad_cmpxchg(volatile void *ptr, int size);
> 
> As long as this only requires 4-byte cmpxchg support then I think this is
> fine. It looks like that's currently the case, so:

Yes and thanks for review.

Yong

> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Will
