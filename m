Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2ILXiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:38:50 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:41747 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab2ILXim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:38:42 -0400
Date: Wed, 12 Sep 2012 23:38:42 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: Vaibhav Hiremath <hvaibhav@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: AM33XX: hwmod: Add OMAP_INTC_START offset to
 all module int nos
In-Reply-To: <20120912215232.GE5997@atomide.com>
Message-ID: <alpine.DEB.2.00.1209122330580.7275@utopia.booyaka.com>
References: <1347484551-11775-1-git-send-email-hvaibhav@ti.com> <1347484551-11775-3-git-send-email-hvaibhav@ti.com> <20120912215232.GE5997@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, 12 Sep 2012, Tony Lindgren wrote:

> * Vaibhav Hiremath <hvaibhav@ti.com> [120912 14:17]:
> > With recent migration of omap architectures to SPARSE_IRQ framework,
> > it is important to add OMAP_INTC_START to all interrupt numbers
> > which will be eventually requested by drivers.
> > 
> > This is required in order to get AM33XX boot functionality.
> > 
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > Cc: Paul Walmsley <paul@pwsan.com>
> > ---
> >  arch/arm/mach-omap2/omap_hwmod_33xx_data.c |  168 ++++++++++++++--------------
> >  1 files changed, 84 insertions(+), 84 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> > index 7b7ed08..3c320f4 100644
> > --- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> > +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> 
> You should just have on top of this file:
> 
> #define OMAP_INTC_START		0
> 
> Then Paul can apply this, and while merging with the sparseirq
> changes, the above can be removed.

This change has been made.

> Then these should be fixed up to have trailing commas
> as requested by Russell earlier on several occasions.

I've taken the script you sent and run it on the data file - thanks for 
the script - and will send the updated pull request shortly.  Sounds like 
Russell should send patches for Documentation/CodingStyle and 
scripts/checkpatch.pl so it can be agreed as a kernel-wide policy.


- Paul
