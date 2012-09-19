Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab2ISLYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:24:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:62209 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab2ISLYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:24:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="224007204"
Date: Wed, 19 Sep 2012 13:23:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mfd: twl: Move PWM driver to PWM framework
Message-ID: <20120919112315.GA8138@sortiz-mobl>
References: <1347956991-16088-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347956991-16088-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Tue, Sep 18, 2012 at 10:29:49AM +0200, Thierry Reding wrote:
> Hi,
> 
> This mini series replaces the twl_has_*() macros by the equivalent
> standard IS_ENABLED() macro and moves the PWM driver to the PWM
> framework.
> 
> I'll take the second patch through the PWM tree but would like to have
> some Acked-bys from people that know and have the hardware and can
> verify that I haven't broken anything.
> 
> Thierry
> 
> Thierry Reding (2):
>   mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
>   pwm: Move TWL6030 PWM driver to PWM framework
Both patches applied now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
