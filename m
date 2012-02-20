Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2BTQzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:55:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:28769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2BTQzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:55:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108674458"
Date: Mon, 20 Feb 2012 18:02:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd/ASoC: Convert WM8994 driver to use regmap patches
Message-ID: <20120220170233.GE5387@sortiz-mobl>
References: <1327327172-8411-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1327327172-8411-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327327172-8411-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jan 23, 2012 at 01:59:31PM +0000, Mark Brown wrote:
> Early revisions of several of the WM8994 variants have register updates
> to improve performance. Move these over to using the regmap patch system
> instead of open coding them in the audio driver. Since the regmap init
> is done by the MFD the code is moved there.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> If possible I'd like to merge this via regmap as the regmap patch
> support is new and won't be in mainline until 3.4.  Is that OK Samuel?
Sounds good to me.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
