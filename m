Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1HRLc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:32:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:49781 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab1HRLcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:32:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,245,1312182000"; 
   d="scan'208";a="39792981"
Date: Thu, 18 Aug 2011 14:33:27 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org
Subject: Re: [PATCH 1/2] mmc: add functions to enable/disable aggressive
 clock gating
Message-ID: <20110818113327.GY16790@intel.com>
References: <e13e177c732ee8ad2d6fe389c9bac21877f60c59.1313400777.git.mika.westerberg@linux.intel.com>
 <CACRpkdZ5oCmRupNn9HjZj534zXJQWD8OpycpMxG4Jhgsvk=kEQ@mail.gmail.com>
 <20110817121914.GW16790@intel.com>
 <20110818103441.GX16790@intel.com>
 <CAHp75VfST5UnPXkCprx5_0UG0tCa2BDCJeAVmkdDi7_7BvQq3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfST5UnPXkCprx5_0UG0tCa2BDCJeAVmkdDi7_7BvQq3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 02:11:23PM +0300, Andy Shevchenko wrote:

> Mika, do the patches to check host->clock in
> (mmc|sdhci)_set_data_timeout() become useless after?
> If so, probably you could revert them as well.

IMHO these functions should work also when the clock is gated, so I suggest
that we leave them as is for now.
