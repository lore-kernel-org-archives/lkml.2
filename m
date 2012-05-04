Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2EDOgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:36:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34288 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab2EDOgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:36:03 -0400
Date: Fri, 4 May 2012 15:35:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wookey <wookey@wookware.org>
Cc: Deepak Saxena <dsaxena@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Kukjin Kim <kgene.kim@samsung.com>, linaro-dev@lists.linaro.org,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120504143518.GF26481@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de> <CAK2p4sJj7FRVSStVkqmn16sUv8S3vHmUYCU_VzTWAWzqV5yVsg@mail.gmail.com> <20120504142057.GQ27023@stoneboat.aleph1.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504142057.GQ27023@stoneboat.aleph1.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 03:20:57PM +0100, Wookey wrote:
> Debian tries very hard not to support anything in the kernel that
> upstream don't support in the kernel because otherwise it's way too
> much work. The current list of supplied arm kernels is:
> 
> iop32x (ThecusN2100, intel SS4000, GLAN tank)
> ixp4xx (Linksys NSLU2)
> kirkwood (*plugs, QNAP NAS, OPenRD)
> orion5x (QNAP NAS, HP mv2120)
> versatile
> mx5
> omap
> 
> because that's a good compromise between coverage and 'building 20-odd
> images'. I have no idea how much of that lot is going to get DTified,
> but I'm guessing the older stuff won't be?

Well, my understanding is that there's DT patches around for Versatile.
OMAP and MX5 are both heading for DT.  I'm less certain about the Orion
and Kirkwood stuff, but as they're only about 4 years old, I would hope
that there was some active movement for these.

The iop32x and ixp4xx stuff hasn't seen much in the way of maintenance
so its highly likely that these won't be converted to DT unless someone
with the hardware decides to step up and do it.

So, that means your list should reduce down to five kernels, or three if
the Orion/Kirkwood stuff gets converted to DT.
