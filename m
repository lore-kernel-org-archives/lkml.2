Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab2J3KjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:39:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36627 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab2J3KjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:39:21 -0400
Message-ID: <1351593554.2831.8.camel@hornet>
Subject: Re: linux-next: manual merge of the clk tree with the arm-soc tree
From: Pawel Moll <pawel.moll@arm.com>
To: Mike Turquette <mturquette@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 30 Oct 2012 10:39:14 +0000
In-Reply-To: <20121030101140.18780.69840@nucleus>
References: <20121030150627.ac1f6a3f75231ea49edf7b98@canb.auug.org.au>
	 <20121030101140.18780.69840@nucleus>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 30 Oct 2012 10:39:13.0838 (UTC) FILETIME=[CDD0FCE0:01CDB68A]
X-MC-Unique: 112103010391709201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 10:11 +0000, Mike Turquette wrote:
> > diff --cc arch/arm/include/asm/hardware/sp810.h
> > index 2cdcf44,afd7e91..0000000
> > --- a/arch/arm/include/asm/hardware/sp810.h
> > +++ b/arch/arm/include/asm/hardware/sp810.h
> > @@@ -50,6 -50,14 +50,8 @@@
> >   #define SCPCELLID2            0xFF8
> >   #define SCPCELLID3            0xFFC
> >   
> >  -#define SCCTRL_TIMEREN0SEL_REFCLK     (0 << 15)
> >  -#define SCCTRL_TIMEREN0SEL_TIMCLK     (1 << 15)
> >  -
> >  -#define SCCTRL_TIMEREN1SEL_REFCLK     (0 << 17)
> >  -#define SCCTRL_TIMEREN1SEL_TIMCLK     (1 << 17)
> >  -
> > + #define SCCTRL_TIMERENnSEL_SHIFT(n)   (15 + ((n) * 2))
> > + 
> >   static inline void sysctl_soft_reset(void __iomem *base)
> >   {
> >         /* switch to slow mode */
> 
> Pawel,
> 
> Does this look OK for you?

Yes, it's correct.

Thanks!

Paweł


