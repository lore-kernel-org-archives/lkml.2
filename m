Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2LLImQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:42:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:36080 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab2LLImP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:42:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,265,1355126400"; 
   d="scan'208";a="179823482"
Message-ID: <1355301722.31620.68.camel@smile>
Subject: Re: [PATCH V3 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, vinod.koul@intel.com,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Dec 2012 10:42:02 +0200
In-Reply-To: <201212102208.52347.arnd@arndb.de>
References: <3100e691db3f94c22afd98b609a1568d7e70dfe7.1350360935.git.viresh.kumar@linaro.org>
	 <169edae67b9a051ca7448e5b62c3cd2c5c1db470.1350360935.git.viresh.kumar@linaro.org>
	 <201212102208.52347.arnd@arndb.de>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 22:08 +0000, Arnd Bergmann wrote: 
> The build bug is not the problem however, but the abuse of the
> API is. Andy, are you sure you understood what this does when
> you gave you Reviewed-by comment?

Thank you for pointing this out to refresh my memories and go through
documentation again.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
