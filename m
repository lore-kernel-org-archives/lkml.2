Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1HSV6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:58:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47928 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750856Ab1HSV6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:58:22 -0400
Date: Fri, 19 Aug 2011 22:58:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Robert Schwebel <rsc@pengutronix.de>
Subject: Re: [PATCH] mfd wm8350: rename static gpio_set_debounce()
Message-ID: <20110819215819.GA3772@opensource.wolfsonmicro.com>
References: <20110810080549.GX31404@pengutronix.de>
 <20110819095326.GB22865@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110819095326.GB22865@pengutronix.de>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 11:53:26AM +0200, Uwe Kleine-König wrote:

> Can you please apply this patch? Even though it works around something
> ugly (IMHO), it fixes a build failure on arm/imx. (Not on a vanilla
> defconfig though.)

Samuel generally only applies patches about once a month or so.
