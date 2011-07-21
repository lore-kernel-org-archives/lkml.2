Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1GUToT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:44:19 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51653 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1GUToR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:44:17 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] iMX28: Fix emi_ddr_open pinmux
Date: Thu, 21 Jul 2011 21:44:12 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-amd64; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
References: <1311264490-5485-1-git-send-email-marek.vasut@gmail.com> <20110721190536.GC16561@pengutronix.de>
In-Reply-To: <20110721190536.GC16561@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107212144.12410.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 21, 2011 09:05:36 PM Uwe Kleine-König wrote:
> On Thu, Jul 21, 2011 at 06:08:10PM +0200, Marek Vasut wrote:
> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > ---
> > 
> >  arch/arm/mach-mxs/include/mach/iomux-mx28.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/mach-mxs/include/mach/iomux-mx28.h
> > b/arch/arm/mach-mxs/include/mach/iomux-mx28.h index f50fefd..1a95ecd
> > 100644
> > --- a/arch/arm/mach-mxs/include/mach/iomux-mx28.h
> > +++ b/arch/arm/mach-mxs/include/mach/iomux-mx28.h
> > @@ -203,7 +203,7 @@
> > 
> >  #define MX28_PAD_EMI_WEN__EMI_WEN			MXS_IOMUX_PAD_NAKED(6, 21,
> >  PAD_MUXSEL_0) #define
> >  MX28_PAD_EMI_CE0N__EMI_CE0N			MXS_IOMUX_PAD_NAKED(6, 22, 
PAD_MUXSEL_0)
> >  #define MX28_PAD_EMI_CE1N__EMI_CE1N			MXS_IOMUX_PAD_NAKED(6, 23,
> >  PAD_MUXSEL_0)
> > 
> > -#define MX28_PAD_EMI_CKE__EMI_CKE			MXS_IOMUX_PAD_NAKED(6, 24,
> > PAD_MUXSEL_0) +#define
> > MX28_PAD_EMI_CKE__EMI_CKE			MXS_IOMUX_PAD_NAKED(6, 26, 
PAD_MUXSEL_0)
> 
> In my version of the i.MX28 Reference Manual (Rev. 1, 2010) pin24 is
> correct. So if you're still convinced that 26 is correct you should point
> out in the commit log that the Reference Manual is wrong and why you're
> convinced it really is.

Scrap this, you're right.
> 
> Best regards
> Uwe
