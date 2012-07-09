Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2GILON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:14:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:9555 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab2GILOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:14:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120280892"
Date: Mon, 9 Jul 2012 13:25:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH 1/6] mfd: max77686: Use pmic regmap to read pmic
 interrupt register.
Message-ID: <20120709112540.GN15345@sortiz-mobl>
References: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder,

On Thu, Jul 05, 2012 at 09:28:20AM +0530, Yadwinder Singh Brar wrote:
> PMIC's regmap should be used to read pmic interrupt registers.
> 
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> ---
>  drivers/mfd/max77686-irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
This one and the 4 other mfd patches applied to my for-next branch. Thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
