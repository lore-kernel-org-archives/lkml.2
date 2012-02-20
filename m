Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab2BTTYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:24:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:22562 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab2BTTYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:24:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68415742"
Date: Mon, 20 Feb 2012 20:31:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/4] AB8500 fixes and AB9540 support
Message-ID: <20120220193146.GM5387@sortiz-mobl>
References: <1328112547-32424-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328112547-32424-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Feb 01, 2012 at 05:09:07PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This breaks the earlier patch to support AB9540 apart into
> smaller pieces, and uses the platform device ID to enforce
> which version of the ASIC is being used.
> 
> Sam: seeking ACKs for these, [1/4] could possibly go into
> the -rc series if you find time for it.
Yes, I will add it to my final fixes pull request to the other Linus.
Could you please fix patch #1 according to Maxime's comments and remove the
board-mop500.c diff from patch #2 ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
