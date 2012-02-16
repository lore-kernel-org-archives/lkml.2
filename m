Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2BPQkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:40:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33079 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2BPQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:40:42 -0500
Date: Thu, 16 Feb 2012 16:40:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Oskar Schirmer <oskar@scara.com>
Cc: sameo@linux.intel.com, dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] mfd: add I2C handling to mc13xxx driver
Message-ID: <20120216164029.GA27239@sirena.org.uk>
References: <1329215672-15706-1-git-send-email-oskar@scara.com>
 <1329215672-15706-4-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329215672-15706-4-git-send-email-oskar@scara.com>
X-Cookie: Results are not typical.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 10:34:28AM +0000, Oskar Schirmer wrote:
> mc13xxx chips may be wired to SPI or I2C, alternatively.
> Up to now, mc13xxx did support SPI wiring solely.
> Add support for I2C wiring, make the two alternatives
> separate menu option in configuration.

As with the last time you posted this it really would be better to
convert this to regmap rather than add new open coded register map I/O
support.
