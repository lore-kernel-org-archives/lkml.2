Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2HLSuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 14:50:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33149 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab2HLSuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 14:50:14 -0400
Date: Sun, 12 Aug 2012 19:50:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
Message-ID: <20120812185012.GB10627@opensource.wolfsonmicro.com>
References: <20120808131356.GS16861@opensource.wolfsonmicro.com>
 <50226CF4.1010202@ti.com>
 <20120808135253.GC16861@opensource.wolfsonmicro.com>
 <502274DA.9020204@ti.com>
 <20120808141849.GA24328@opensource.wolfsonmicro.com>
 <50227837.10400@ti.com>
 <20120808144933.GC24328@opensource.wolfsonmicro.com>
 <50238E8A.5030902@ti.com>
 <20120809103600.GI24328@opensource.wolfsonmicro.com>
 <5023C0D6.8040600@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023C0D6.8040600@ti.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:53:26PM +0300, Peter Ujfalusi wrote:
> On 08/09/2012 01:36 PM, Mark Brown wrote:

> > Is there any actual case where an external mute is supplied via a
> > mechanism other than a GPIO, and if there is would it not either need
> > its own DT property or already need to interact with the driver from
> > code, making the DT property redundant?

> Not with my knowledge. The only board using it is the zoom2 upstream. I know
> other boards (not in upstream) which either uses the internal mute or GPIO.

OK, so we can probably only support GPIO for now then worry about other
external mutes when there's something to work with.
