Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab1AULO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 06:14:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35428 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1AULO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 06:14:57 -0500
Date: Fri, 21 Jan 2011 11:14:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vexpress: register platform PATA device.
Message-ID: <20110121111432.GO13235@n2100.arm.linux.org.uk>
References: <1294435445-2020-1-git-send-email-nbowler@elliptictech.com> <20110107224348.GZ31708@n2100.arm.linux.org.uk> <20110110211622.GA10381@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110211622.GA10381@elliptictech.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 04:16:22PM -0500, Nick Bowler wrote:
> On 2011-01-07 22:43 +0000, Russell King - ARM Linux wrote:
> > On Fri, Jan 07, 2011 at 04:24:05PM -0500, Nick Bowler wrote:
> > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > index d56d21c..ee61039 100644
> > > --- a/arch/arm/Kconfig
> > > +++ b/arch/arm/Kconfig
> > > @@ -264,6 +264,7 @@ config ARCH_VEXPRESS
> > >  	select HAVE_CLK
> > >  	select ICST
> > >  	select PLAT_VERSATILE
> > > +	select HAVE_PATA_PLATFORM
> > 
> > To avoid the Kconfig warning, this should be:
> > 
> > 	select HAVE_PATA_PLATFORM if ATA
> > 
> > or it needs to be moved outside of the if ATA ... endif block in
> > drivers/ata/Kconfig.
> 
> The Kconfig dependency fix was merged into mainline today, so this patch
> should no longer trigger the aforementioned warning.

Ok, can you put it in the patch system please?

Thanks.
