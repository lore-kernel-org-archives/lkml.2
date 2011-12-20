Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1LTBT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:19:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38357 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab1LTBT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:19:27 -0500
Date: Tue, 20 Dec 2011 01:19:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v4 3/4] regulator: simplify twl4030 config
Message-ID: <20111220011923.GS2860@opensource.wolfsonmicro.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
 <1324343717-7292-4-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324343717-7292-4-git-send-email-felipe.contreras@gmail.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 03:15:16AM +0200, Felipe Contreras wrote:
> If we have TWL4030_CORE and REGULATOR, we *obviously* want
> REGULATOR_TWL4030 by default. But can be disabled if somebody wants for
> some strange reason.

No, this is the wrong way to go about this - why are you making this
change for this one driver only?  Exactly the same argument would apply
to all the other MFD regulators and to all the other MFD subdrivers in
the various subsystems.
