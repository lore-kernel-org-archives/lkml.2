Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1I2JoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:44:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54060 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab1I2JoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:44:06 -0400
Date: Thu, 29 Sep 2011 10:44:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: ashishj3 <ashish.jangam@kpitcummins.com>, sameo@linux.intel.com,
        m.grzeschik@pengutronix.de, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>
Subject: Re: [Patch v4 08/11] Touch: DA9052 touchscreen driver
Message-ID: <20110929094404.GB3697@opensource.wolfsonmicro.com>
References: <1317277349.4828.9.camel@L-0761.kpit.com>
 <20110929080313.GA23127@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929080313.GA23127@core.coreip.homeip.net>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 01:03:13AM -0700, Dmitry Torokhov wrote:

> Please feel free to merge with the rest of your patches (I assume
> through MFD tree).

Actually for new MFDs it's usually OK to merge via the subsystem trees -
the dependency on the core driver prevents build breakage by ensuring
that the driver can't be selected until the MFD is there.
