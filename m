Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2IYNWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:22:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:55350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab2IYNWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:22:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,483,1344236400"; 
   d="scan'208";a="212687476"
Date: Tue, 25 Sep 2012 15:22:12 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 4/4] mfd: max8907: remove regulator-compatible from DT
 docs
Message-ID: <20120925132212.GO28670@sortiz-mobl>
References: <1348514703-10152-1-git-send-email-swarren@wwwdotorg.org>
 <1348514703-10152-5-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348514703-10152-5-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Sep 24, 2012 at 01:25:03PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Commit "regulator: deprecate regulator-compatible DT property" deprecated
> the use of the regulator-compatible DT property. Update the DT example in
> the MAX8907 binding documentation to reflect this.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This commit is based on the MFD branch.
> ---
>  .../devicetree/bindings/regulator/max8907.txt      |   24 ++++++-------------
>  1 files changed, 8 insertions(+), 16 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
