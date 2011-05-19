Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab1ESMBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:01:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:55736 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab1ESMBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:01:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,237,1304319600"; 
   d="scan'208";a="439005217"
Subject: Re: [PATCH] dmaengine: move link order
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1305721137-11433-1-git-send-email-linus.walleij@stericsson.com>
References: <1305721137-11433-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 16:58:17 +0530
Message-ID: <1305804497.28926.304.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 14:18 +0200, Linus Walleij wrote:
> Move the dmaengine subsystem up early in the drivers Makefile so
> DMA is made available early to all drivers, just like e.g.
> regulators. Now even regulators can use DMA on the same initlevel.
> As a result we can bump the ste_dma40 and coh901318 dmaengine
> drivers down one initlevel to subsys_init().
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/Makefile        |    4 +++-
>  drivers/dma/coh901318.c |    2 +-
>  drivers/dma/ste_dma40.c |    2 +-
>  3 files changed, 5 insertions(+), 3 deletions(-)
Applied thanks....

Hadn't read the patch fully so ignore my comment on st-dma

-- 
~Vinod

