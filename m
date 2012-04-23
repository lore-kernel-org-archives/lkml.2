Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2DWMm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:42:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:32256 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2DWMmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:42:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144837817"
Subject: Re: [PATCH 0/2] dmaengine fixes for the -rc:s
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1334247139-17316-1-git-send-email-linus.walleij@stericsson.com>
References: <1334247139-17316-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Apr 2012 18:08:58 +0530
Message-ID: <1335184738.31825.113.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 18:12 +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> These two fixes are critical for the ux500 to work on the v3.4-rc2
> series. Enjoy!
> 
> Linus Walleij (2):
>   dma/ste_dma40: explicitly include regulator consumer header
>   dma/ste_dma40: fix erroneous comparison
> 
>  drivers/dma/ste_dma40.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
Both Applied, Thanks

And will send for rc5 in couple of days.


-- 
~Vinod

