Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1IZJ4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:56:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:11095 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1IZJ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:56:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56461204"
Date: Mon, 26 Sep 2011 11:58:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        khilman@ti.com, santosh.shilimkar@ti.com, premi@ti.com,
        david.woodhouse@intel.com, christian.gmeiner@gmail.com
Subject: Re: [PATCH v3 3/3] OMAP3: Remove auto-selection of PMICs
Message-ID: <20110926095848.GF32263@sortiz-mobl>
References: <1316698155-954-1-git-send-email-abhilash.kv@ti.com>
 <1316698155-954-2-git-send-email-abhilash.kv@ti.com>
 <1316698155-954-3-git-send-email-abhilash.kv@ti.com>
 <1316698155-954-4-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316698155-954-4-git-send-email-abhilash.kv@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

On Thu, Sep 22, 2011 at 06:59:15PM +0530, Abhilash K V wrote:
> The current implementation almost assumes that only
> TWL4030/TWL5030/TWl6030 are (or can be) used with the
> OMAP processors. This is, however, not true.
> 
> This patch removes the automatic selection of the PMIC
> from Kconfig.
> All currently used PMICs are now added to omap2plus_defconfig;
> any new PMIC that gets supported in future could now be
> enabled here rather than by changing Kconfig for
> ARCH_OMAP2PLUS_TYPICAL
> 
> Signed-off-by: Sanjeev Premi <premi@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/configs/omap2plus_defconfig |    3 +++
>  arch/arm/mach-omap2/Kconfig          |    3 ---
>  drivers/mfd/Kconfig                  |    2 +-
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

for the MFD part.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
