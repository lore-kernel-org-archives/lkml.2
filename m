Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2KMTEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:04:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:64797 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab2KMTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:04:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,768,1344236400"; 
   d="scan'208";a="246481199"
Date: Tue, 13 Nov 2012 20:04:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] mfd: tps6586x: Convert to irq domain
Message-ID: <20121113190419.GP27828@sortiz-mobl>
References: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Tue, Nov 13, 2012 at 07:18:04PM +0530, Laxman Dewangan wrote:
> This patch series convert the irq implementation to use the
> irq domain.
> Accordingly, gpio driver and rtc registration is updated.
> 
> Reposting the series and adding the reviwed by Mark and acked by Linus W
> for the respective patches.
Thanks for the repost and for adding the reviewers and ackers name.
This patchset is applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
