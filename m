Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2GLBKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 21:10:19 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:52166
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023Ab2GLBKQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 21:10:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIc89bh1432Izz1202hzz8275dhz2dh87h2a8h668h839hd25he96hf0ah107ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 12 Jul 2012 09:10:40 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC internal PATCH] mfd/mc13xxx: drop modifying driver's
 id_table in probe
Message-ID: <20120712011038.GB6971@S2101-09.ap.freescale.net>
References: <1342006608-30550-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1342006608-30550-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The code was added by me, and it turns out the change is completely
unnecessary.  So,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Regards,
Shawn

