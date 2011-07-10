Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1GJC7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 22:59:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51593 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755234Ab1GJC7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 22:59:33 -0400
Date: Sun, 10 Jul 2011 11:59:24 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regmap: Add I2C bus support
Message-ID: <20110710025922.GB19971@opensource.wolfsonmicro.com>
References: <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110709115307.GA19804@pengutronix.de>
 <20110709140833.GA17655@opensource.wolfsonmicro.com>
 <20110709145733.GA1893@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110709145733.GA1893@pengutronix.de>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 04:57:33PM +0200, Wolfram Sang wrote:
> On Sat, Jul 09, 2011 at 11:08:36PM +0900, Mark Brown wrote:

> > Remind me of what you're talking about here?

> He suggested including init.h, because of the use of postcore_initcall.

Oh, right.  Thought I'd done that too actually.

> That's minor, of course. But you probably need to resend anyway, because
> of the mangling-check in the read function.

Possibly not, actually - as Greg acked it I'm probably going to try a
pull request during the merge window and see how that goes.

> abstracting I2C/SPI-access away. Will surely try to convert a driver
> myself.

Please send me any patches for that and I'll add them to the series.
