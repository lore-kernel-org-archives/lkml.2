Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1AJVQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:16:35 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:51496 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754733Ab1AJVQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:16:33 -0500
Date: Mon, 10 Jan 2011 16:16:22 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vexpress: register platform PATA device.
Message-ID: <20110110211622.GA10381@elliptictech.com>
References: <1294435445-2020-1-git-send-email-nbowler@elliptictech.com>
 <20110107224348.GZ31708@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107224348.GZ31708@n2100.arm.linux.org.uk>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-07 22:43 +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 07, 2011 at 04:24:05PM -0500, Nick Bowler wrote:
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index d56d21c..ee61039 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -264,6 +264,7 @@ config ARCH_VEXPRESS
> >  	select HAVE_CLK
> >  	select ICST
> >  	select PLAT_VERSATILE
> > +	select HAVE_PATA_PLATFORM
> 
> To avoid the Kconfig warning, this should be:
> 
> 	select HAVE_PATA_PLATFORM if ATA
> 
> or it needs to be moved outside of the if ATA ... endif block in
> drivers/ata/Kconfig.

The Kconfig dependency fix was merged into mainline today, so this patch
should no longer trigger the aforementioned warning.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
