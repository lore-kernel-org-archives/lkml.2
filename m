Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1KYPeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 10:34:14 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43773 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1KYPeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 10:34:13 -0500
Date: Fri, 25 Nov 2011 15:34:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Message-ID: <20111125153409.GA4975@sirena.org.uk>
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
X-Cookie: bug, n:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 03:08:39PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:

> +/**
> + * gpio_set_pullup - sets @pullup for a @gpio
> + * @gpio: the gpio to set pullup
> + * @pullup: pullup level
> + */
> +int gpio_set_pullup(unsigned gpio, unsigned pullup)

This has some overlap with the pinmux subsystem.  We also need
documentation of what the pullup values mean.
