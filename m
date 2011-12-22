Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1LVRZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:25:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:1630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab1LVRZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:25:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88635446"
Date: Thu, 22 Dec 2011 18:31:06 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: rob.herring@calxeda.com, tony@atomide.com, linux-omap@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org, ben-linux@fluff.org,
        Balaji T K <balajitk@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v4 03/12] mfd: twl-core: Add initial DT support for
 twl4030/twl6030
Message-ID: <20111222173106.GJ5183@sortiz-mobl>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
 <1324565806-31142-4-git-send-email-b-cousson@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324565806-31142-4-git-send-email-b-cousson@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Thu, Dec 22, 2011 at 03:56:37PM +0100, Benoit Cousson wrote:
> Add initial device-tree support for twl familly chips.
> The current version is missing the regulator entries due
> to the lack of DT regulator bindings for the moment.
> Only the simple sub-modules that do not depend on
> platform_data information can be initialized properly.
> 
> Add irqdomain support.
> 
> Add documentation for the Texas Instruments TWL Integrated Chip.
> 
> Signed-off-by: Benoit Cousson <b-cousson@ti.com>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Graeme Gregory <gg@slimlogic.co.uk>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  .../devicetree/bindings/mfd/twl-familly.txt        |   47 ++++++++++++++++++
>  drivers/mfd/Kconfig                                |    1 +
>  drivers/mfd/twl-core.c                             |   51 +++++++++++++++++++-
>  3 files changed, 98 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/twl-familly.txt
Patch applied instead of the previous one, thanks for the quick fix.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
