Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746Ab2EKNQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:16:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:57218 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab2EKNQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:16:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141873019"
Date: Fri, 11 May 2012 15:25:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm8400: Remove custom cache implementation
Message-ID: <20120511132545.GK1214@sortiz-mobl>
References: <1336600428-13238-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336600428-13238-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, May 09, 2012 at 10:53:48PM +0100, Mark Brown wrote:
> Save a useful amount of code by removing the custom cache implementation
> for wm8400 and using the regmap cache. Also simplify things by not
> separately reseting the CODEC registers, this is a sufficiently infrequent
> operation that we can simply invalidate the entire cache when this happens.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8400-core.c          |  251 +++++-------------------------------
>  include/linux/mfd/wm8400-private.h |   14 +-
>  2 files changed, 42 insertions(+), 223 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
