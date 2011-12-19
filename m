Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1LSLWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:22:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:62365 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1LSLWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:22:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97856462"
Date: Mon, 19 Dec 2011 12:26:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111219112640.GG11800@sortiz-mobl>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Dec 02, 2011 at 02:56:22PM +0100, Linus Walleij wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> Simple HV LED controller driver for AB5500v1.0 MFD chips
> 
> Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Tested-by: Naga Radesh Y <naga.radheshy@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> This depends on the other movement patch since it handily puts the
> platform data header in <linux/mfd/abx500/ab5500-leds.h>.
So I'm pushing this one through. Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
