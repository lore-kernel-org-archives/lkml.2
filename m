Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2DBQBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:01:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56492 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2DBQBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:01:05 -0400
Date: Mon, 2 Apr 2012 17:00:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, alexg@meprolight.com
Subject: Re: [PATCH v5 2/4] mfd: mc13xxx-core: use regmap for register
 access
Message-ID: <20120402160036.GA29808@sirena.org.uk>
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
 <1333262499-25871-3-git-send-email-marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333262499-25871-3-git-send-email-marc@cpdesign.com.au>
X-Cookie: "Out of register space (ugh)"
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 04:41:37PM +1000, Marc Reilly wrote:
> This change converts the mc13xxx core to use regmap rather than direct
> spi r/w.
> The spidev member of mc13xxx struct becomes redundant and is removed.
> Extra debugging aids are added to mc13xxx_reg_rmw.

To repeat what I've said on previous versions please push this down into
regmap.  There's already extensive diagnostic features there, let's not
have people open coding things that are missing.
