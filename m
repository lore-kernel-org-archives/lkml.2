Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab2INH4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:56:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:46880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab2INH4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:56:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,422,1344236400"; 
   d="scan'208";a="222070652"
Date: Fri, 14 Sep 2012 09:56:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCH] staging: nvec: adjust for mfd_add_devices() API change
Message-ID: <20120914075605.GD3647@sortiz-mobl>
References: <1347467160-22724-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347467160-22724-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Sep 12, 2012 at 10:26:00AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Commit 6607bad "mfd: core: Push irqdomain mapping out into devices"
> added a new parameter to mfd_add_devices(), but missed updating the
> nvec driver in staging.
> 
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Marc Dietrich <marvin24@gmx.de>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> --
> Samuel, I wonder if this patch should be squashed into the commit mentioned
> above in the MFD tree?
It does make sense. Squashed and pushed now, thanks for catching this one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
