Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab1LNMAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 07:00:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59717 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab1LNL77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:59:59 -0500
Date: Wed, 14 Dec 2011 11:59:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Message-ID: <20111214115954.GB25088@sirena.org.uk>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Cookie: Inside, I'm already SOBBING!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 01:23:31PM -0500, Kyle Moffett wrote:

> I'm working on support for some custom hardware of ours, and part of
> the support code is the ability for the software to shutdown the power
> supply using GPIOs (via an I2C GPIO controller).

We already have the regulator API for controlling power to devices,
simple GPIO supplies are supported using fixed voltage regulators.  The
drivers that are being turned off should have regulator support added to
them.  If we have a separate method for doing GPIOs then drivers would
have to support multiple methods of controlling their power.
