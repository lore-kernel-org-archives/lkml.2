Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab2CSMAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:00:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57498 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab2CSMAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:00:40 -0400
Date: Mon, 19 Mar 2012 12:00:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] mfd: mc13xxx-core: use regmap for register
 access
Message-ID: <20120319120015.GA5705@sirena.org.uk>
References: <1332129838-7080-1-git-send-email-marc@cpdesign.com.au>
 <1332129838-7080-3-git-send-email-marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332129838-7080-3-git-send-email-marc@cpdesign.com.au>
X-Cookie: Uncompensated overtime?  Just Say No.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:03:56PM +1100, Marc Reilly wrote:
> This change converts the mc13xxx core to use regmap rather than direct
> spi r/w.
> The spidev member of mc13xxx struct becomes redundant and is removed.
> Extra debugging aids are added to mc13xxx_reg_rmw.
> Mutex init is moved to before regmap init.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though like I said it'd be good to get the rmw trace into regmap - if
it's useful to you here similar trace is probably going to be useful to
other users.
