Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2ILIjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:39:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:21821 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab2ILIjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:39:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,408,1344236400"; 
   d="scan'208";a="202075209"
Date: Wed, 12 Sep 2012 10:39:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/ab3100: split ab3100 headers out of abx500.h
Message-ID: <20120912083916.GZ3647@sortiz-mobl>
References: <1344587555-8454-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344587555-8454-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 10, 2012 at 10:32:35AM +0200, Linus Walleij wrote:
> From: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> 
> The U8500 has its own set of separate header, so the abx500
> becomes completely abstract. Do the same split for the AB3100
> legacy ASIC.
> 
> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/mach-u300/i2c.c   |   2 +-
>  drivers/mfd/ab3100-core.c  |   1 +
>  drivers/regulator/ab3100.c |   1 +
>  include/linux/mfd/ab3100.h | 129 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/abx500.h | 117 +---------------------------------------
>  5 files changed, 133 insertions(+), 117 deletions(-)
>  create mode 100644 include/linux/mfd/ab3100.h
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
