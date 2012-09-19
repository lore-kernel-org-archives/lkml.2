Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2ISLZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:25:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:58207 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2ISLZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="194483465"
Date: Wed, 19 Sep 2012 13:25:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: broonie@opensource.wolfsonmicro.com, ldewangan@nvidia.com,
        bilhuang@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH REPOST] mfd: max8907: add power off control
Message-ID: <20120919112546.GB8138@sortiz-mobl>
References: <1348008679-20582-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348008679-20582-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Sep 18, 2012 at 04:51:19PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Add DT property "maxim,system-power-controller" to indicate whether the
> PMIC is in charge of controlling the system power. If this is set, the
> driver will provide the pm_power_off() function.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Samuel, I'm not sure if you have this in your list to process or not, nor
> if you prefer a patch to be reposted vs. a response to the original email;
> Mark Brown requested that for him at least I repost rather than reply, so
> I'm giving that a go everywhere.
Thanks for reposting. Patch is applied to my for-next branch now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
