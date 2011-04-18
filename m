Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1DRKfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:35:55 -0400
Received: from linux-sh.org ([111.68.239.195]:51226 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab1DRKfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:35:48 -0400
Date: Mon, 18 Apr 2011 19:35:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, w.sang@pengutronix.de, arnd@arndb.de
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Message-ID: <20110418103513.GA27864@linux-sh.org>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:50:54AM +0200, Michal Simek wrote:
> Adding OF binding to genirq.
> Version string is setup to the "devicetree".
> 
> Compatible string is not setup for now but you can add your
> custom compatible string to uio_of_genirq_match structure.
> 
> For example with "uio" compatible string:
> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> 	{ .compatible = "uio", },
> 	{ /* empty for now */ },
> };
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
Perhaps a silly question, but how are you planning on differentiating
between uio_pdrv and uio_pdrv_genirq binding if someone has both enabled?

uio_pdrv obviously doesn't have OF bindings at the moment, but it seems
like you could easily parse the memory ranges in addition to the IRQ and
come up with a generic binding that would work for both.

We also have a shiny new Documentation/devicetree these days, so it would
be nice to see the binding documented at the same time.
