Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2F2P0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:26:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:22468 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab2F2P0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:26:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159749506"
Date: Fri, 29 Jun 2012 17:37:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3] mfd: wm8350: Add regmap cache support
Message-ID: <20120629153725.GK22806@sortiz-mobl>
References: <1338727044-23960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338727044-23960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Jun 03, 2012 at 01:37:22PM +0100, Mark Brown wrote:
> Use the most simple possible transformation on the existing code so keep
> the table sitting around, further patches in this series will delete the
> existing cache code - the main purpose of this patch is to ensure that
> we always have a cache for bisection.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-core.c       |   29 ++++++++++++--------
>  drivers/mfd/wm8350-i2c.c        |    5 ----
>  drivers/mfd/wm8350-regmap.c     |   56 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/wm8350/core.h |    7 ++++-
>  4 files changed, 80 insertions(+), 17 deletions(-)
This one and the 2 next ones applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
