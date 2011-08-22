Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1HVKLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:11:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:15894 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab1HVKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,262,1312182000"; 
   d="scan'208";a="42632387"
Date: Mon, 22 Aug 2011 12:13:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Robert Schwebel <rsc@pengutronix.de>
Subject: Re: [PATCH] mfd wm8350: rename static gpio_set_debounce()
Message-ID: <20110822101330.GL4607@sortiz-mobl>
References: <20110810080549.GX31404@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810080549.GX31404@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Wed, Aug 10, 2011 at 10:05:49AM +0200, Sascha Hauer wrote:
> 
> The kernel already has a function with this name declared
> in asm-generic/gpio.h. So if this header leaks into wm8350/gpio.c
> we get
> 
> drivers/mfd/wm8350-gpio.c:40:12: error: conflicting types for 'gpio_set_debounce'
> include/asm-generic/gpio.h:156:12: note: previous declaration of 'gpio_set_debounce' was here
> 
> Fix this by adding a wm8350_ prefix to the function.
Thanks for the fix, I applied this patch to both of my branches.
I'll send a pull request for the MFD fixes soon.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
