Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2GPNlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:41:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:40950 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab2GPNlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:41:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="166905768"
Date: Mon, 16 Jul 2012 15:41:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC internal PATCH] mfd/mc13xxx: drop modifying driver's
 id_table in probe
Message-ID: <20120716134151.GH20652@sortiz-mobl>
References: <1342006608-30550-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1342006608-30550-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Wed, Jul 11, 2012 at 01:36:48PM +0200, Uwe Kleine-König wrote:
> This was introduced in commit
> 
> 	876989d (mfd: Add device tree probe support for mc13xxx)
> 
> for spi and later while introducing support for i2c copied to the i2c
> driver.
> 
> Modifying driver details is very strange, for example probing an
> mc13892 device (instantiated via dt) removes the driver's ability to
> handle (traditionally probed) mc13783 devices in this case.
> I'm not aware of any problems that make this hack necessary and if
> there were some, they'd have to be fixed in the spi/i2c core, not in
> a driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello Samuel,
> 
> even though this qualifies as fix, I don't think it's necessary to annoy
> Linus with it for 3.5. Usually there is only one pmic on each machine so
> it's not grave when probing one device disables support for another.
I agree, and I'm pushing this one for the next merge window.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
