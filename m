Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab2JIHET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:04:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35240 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab2JIHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:04:18 -0400
Date: Tue, 9 Oct 2012 16:04:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>, "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] regulator: tps65090: add external control support
 for DCDC
Message-ID: <20121009070407.GU8237@opensource.wolfsonmicro.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
 <1349536671-31714-7-git-send-email-ldewangan@nvidia.com>
 <20121009062841.GL8237@opensource.wolfsonmicro.com>
 <5073C25F.4030900@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5073C25F.4030900@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:51:19AM +0530, Laxman Dewangan wrote:
> On Tuesday 09 October 2012 11:58 AM, Mark Brown wrote:

> >There's support for GPIO driven enable lines in the framework already,
> >this driver should be able to use this happily, this sort of hardware is
> >exactly the use case it was written for.

> yes, I am using the gpio driven enable lines in the framework.
> This patch does the some configuration in register to enable external
> control and configure the regulator_config (fill gpio related stuff
> in config)  before registering
> the regulator. There is no call of gpio libs from the driver.

The code seemed way more complex than that...  did you notice the fact
that if a GPIO is specified then the register enable/disable control
will be ignored if provided?
