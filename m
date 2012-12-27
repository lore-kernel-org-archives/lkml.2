Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2L0Sfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:35:32 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:50579 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2L0Sfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:35:30 -0500
Date: Thu, 27 Dec 2012 20:35:24 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, tony@atomide.com,
        linux@arm.linux.org.uk, balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 0/3] ARM: dts: omap: add dt data for MUSB
Message-ID: <20121227183524.GB7097@blackmetal.musicnaut.iki.fi>
References: <1348047128-25692-1-git-send-email-kishon@ti.com>
 <505A8BAB.2020004@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505A8BAB.2020004@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 20, 2012 at 05:21:15AM +0200, Benoit Cousson wrote:
> On 09/19/2012 11:32 AM, Kishon Vijay Abraham I wrote:
> > This patch series adds dt data to get MUSB working in omap4 and omap3
> > 
> > Changes from v2:
> > * Changes the subject of all the patches to include "ARM: dts:"
> > * Added reg property and interrupt property for "usb_otg_hs". Previously these
> >   were obtained from ti,hwmods property.
> > * Rebased on
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git devel-dt
> > 
> > Changes from v1:
> > Just removed the omap-usb2 dt data and sent that as a separate patch.
> > 
> > Kishon Vijay Abraham I (3):
> >   ARM: dts: Add twl6030-usb data
> >   ARM: dts: Add twl4030-usb data
> >   ARM: dts: omap: Add usb_otg and glue data
> 
> Thanks for the update. I've just pulled the series for 3.7.

I wonder what happened to the patch #3 (Add usb_otg and glue data)
of this series? Why was it dropped? I cannot see it in 3.7 or 3.8-rc1.

A.
