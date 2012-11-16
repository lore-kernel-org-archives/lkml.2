Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2KPP3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:29:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:13137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2KPP3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:29:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,265,1352102400"; 
   d="scan'208";a="220684132"
Date: Fri, 16 Nov 2012 17:32:32 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        spear-devel <spear-devel@list.st.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/6] dmaengine: introduce is_slave_xfer function
Message-ID: <20121116153232.GW17774@intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1353074360-1903-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20121116142104.GT17774@intel.com>
 <CAHp75Vevs1NYkE_Js7m9gAxqO=j9UuJZk-KgOsvEp6Svd3FwmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vevs1NYkE_Js7m9gAxqO=j9UuJZk-KgOsvEp6Svd3FwmQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 05:26:07PM +0200, Andy Shevchenko wrote:
> > I wonder if the above function need some prefix like
> > dmaengine_is_slave_xfer()?
> 
> is_dma_slave_xfer seems more consistent with other helper functions.
> 
> But is_slave_xfer is vacant anyway. I like shorter names.

Fair enough.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
