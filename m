Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab2HHOSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:18:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40007 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757548Ab2HHOSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:18:52 -0400
Date: Wed, 8 Aug 2012 15:18:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
Message-ID: <20120808141849.GA24328@opensource.wolfsonmicro.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
 <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com>
 <20120808131356.GS16861@opensource.wolfsonmicro.com>
 <50226CF4.1010202@ti.com>
 <20120808135253.GC16861@opensource.wolfsonmicro.com>
 <502274DA.9020204@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502274DA.9020204@ti.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 05:16:58PM +0300, Peter Ujfalusi wrote:
> On 08/08/2012 04:52 PM, Mark Brown wrote:

> > Is the point it's at in the sequence the end?

> On both ends :o
> On HS enable: the extmute has to be enabled, run the power on sequence for the
> HS, wait for ramp, disable the HS extmute.

> On stop: enable the extmute, run the sequence, wait for ramp, release the extmute.

I'm struggling to see any reason not to just hold the external mute on
for the entire time the headset is powered off?

> > We can always add a patch stubbing it out as part of the series, or in a
> > branch in the OF tree that we can pull in.

> If you are OK with the hassle I can add a patch to the series for
> include/linux/of.h to handle this.

Yes, please.
