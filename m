Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab2IKQHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:07:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:62065 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2IKQHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:07:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,406,1344236400"; 
   d="scan'208";a="143845520"
Date: Tue, 11 Sep 2012 18:07:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Bill Huang <bilhuang@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        broonie@opensource.wolfsonmicro.com, ldewangan@nvidia.com,
        thierry.reding@avionic-design.de, swarren@wwwdotorg.org,
        xxie@nvidia.com, lrg@slimlogic.co.uk, jhovold@gmail.com,
        kyle.manna@fuel7.com, rklein@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mfd: dt: add power off support for Tegra20/Tegra30
Message-ID: <20120911160707.GT3647@sortiz-mobl>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

On Sun, Aug 19, 2012 at 06:07:54PM -0700, Bill Huang wrote:
> This patch series add new property into regulator DT for telling whether or not
> to hook pmic's power off routine to system call "pm_power_off".
> 
> Patch 1 add power off support for Tegra20 boards using TPS6586x
> Patch 2 add power off support for Tegra30 boards using TPS65910
> 
> Verified on Seaboard (Tegra20) and Cardhu (Tegra30)
> 
> V2:
> * Take multiple pmic instances into consideration while assigning global variables
>   as per suggestion from Thierry Reding <thierry.reding@avionic-design.de>
> 
> V1:
> * Based on master branch of sameo/mfd-2.6.git
> 
> Bill Huang (2):
>   mfd: dt: tps6586x: Add power off control
>   mfd: dt: tps65910: add power off control
> 
>  Documentation/devicetree/bindings/mfd/tps65910.txt |    4 +++
>  .../devicetree/bindings/regulator/tps6586x.txt     |    6 +++++
>  drivers/mfd/tps6586x.c                             |   19 +++++++++++++++++
>  drivers/mfd/tps65910.c                             |   22 ++++++++++++++++++++
>  include/linux/mfd/tps6586x.h                       |    1 +
>  include/linux/mfd/tps65910.h                       |    3 ++
>  6 files changed, 55 insertions(+), 0 deletions(-)
I applied those 2 patches to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
