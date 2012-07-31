Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2GaRWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:22:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51760 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876Ab2GaRWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:22:31 -0400
Date: Tue, 31 Jul 2012 18:22:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: arizona: convert to regmap_add_irq_chips
Message-ID: <20120731172228.GK11892@opensource.wolfsonmicro.com>
References: <1343415776-27176-1-git-send-email-swarren@wwwdotorg.org>
 <20120729203854.GF4384@opensource.wolfsonmicro.com>
 <5016BEC4.5000600@wwwdotorg.org>
 <20120730180352.GR4468@opensource.wolfsonmicro.com>
 <501813F5.6020607@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501813F5.6020607@wwwdotorg.org>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 11:20:53AM -0600, Stephen Warren wrote:

> I agree in general, but I don't see how this is a regression in this
> change - the arizona pdata doesn't specify an IRQ base anywhere, and
> hence the IRQ base is already dynamically allocated...

> The (regmap-irq) API (in the patch I sent) does support optionally
> specifying a base if you want, it's just that the arizona-irq.c patch I
> sent didn't specify a base, since the original code didn't.

I see.  It sounded like the regmap patch had the regression, not the
device specific patch.
