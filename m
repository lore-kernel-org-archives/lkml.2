Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab2IFVCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:02:48 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:41395 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933123Ab2IFVCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:02:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18F2rtDiM9+a7/P35N299og
Date: Thu, 6 Sep 2012 14:02:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Tero Kristo <t-kristo@ti.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/14] ARM: OMAP/ASoC: Zoom2: Let the codec to
 handle the hs_extmute GPIO
Message-ID: <20120906210235.GP1303@atomide.com>
References: <1346933541-21547-1-git-send-email-peter.ujfalusi@ti.com>
 <1346933541-21547-11-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346933541-21547-11-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [120906 05:13]:
> Remove the use of set_hs_extmute callback and let the codec driver to
> handle the extmute GPIO.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  arch/arm/mach-omap2/board-zoom-peripherals.c  | 9 ++-------
>  arch/arm/mach-omap2/include/mach/board-zoom.h | 2 --

Here board-zoom.h will be moved to be just #include "board-zoom.h".
But we can deal with that once I have an immutable header cleanup
branch that you can pull in.

Acked-by: Tony Lindgren <tony@atomide.com>
