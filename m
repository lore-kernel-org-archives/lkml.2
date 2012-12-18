Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2LRP0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:26:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55855 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2LRP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:26:30 -0500
Date: Tue, 18 Dec 2012 15:26:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jun Chen <jun.d.chen@intel.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Bi Chao <chao.bi@intel.com>, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: Add the flag indicate to registe new device as
 children of master or not.
Message-ID: <20121218152623.GA26077@sirena.org.uk>
References: <1355848174.1435.25.camel@chenjun-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355848174.1435.25.camel@chenjun-workstation>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:29:34AM -0500, Jun Chen wrote:

>   * @master: Controller to which device is connected
> + * device_was_children_of_master is flag which the device is registed
> + * as the children of the bus

This isn't a kerneldoc style comment (it needs the @XXX: format).  The
name is also extremely long, can't we think of something more concise?

> -	spi->dev.parent = &master->dev;
> +	if (device_was_children_of_master == true)
> +		spi->dev.parent = &master->dev;
> +	else
> +		spi->dev.parent = dev;

Can you provide an example of where this is useful?  Your changelog
didn't make it clear and the code doesn't make it obvious either.
