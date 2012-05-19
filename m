Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab2ESPWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 11:22:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:63119 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab2ESPWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 11:22:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168504668"
Date: Sat, 19 May 2012 17:32:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH v3 0/4] MFD: twl6040: Device tree support
Message-ID: <20120519153236.GQ12015@sortiz-mobl>
References: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, May 16, 2012 at 02:11:54PM +0300, Peter Ujfalusi wrote:
> Hello,
> 
> Changes since v2:
> - Child devices are no longer described in dts, they are created with
>   mfd_add_devices()
> - ASoC codec device is created unconditionally (main function of twl6040)
> 
> Changes since v1:
> - Commit message for patch 2 (Allocate IRQ numbers dynamically) has been updated
>   to describe that the twl6040 can not be used as IRQ extender type of device.
> 
> Commit message from v1:
> 
> The following series adds device tree support for the twl6040 MFD core driver.
> Support for the child drivers (vibra, ASoC codec) will be submitted via the
> corresponding subsystem since there is no compile time dependency between them.
> 
> The first patch is a minor clean up patch to remove wrapped lines in the
> twl6040-irq.c. The resulting code is more natural to read to me.
> 
> The series depends on the regulator support patch for the twl6040:
> http://marc.info/?l=linux-kernel&m=133596703610515&w=2
All 4 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
