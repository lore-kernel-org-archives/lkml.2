Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab2BALb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:31:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38971 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2BALb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:31:57 -0500
Date: Wed, 1 Feb 2012 11:31:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Michel Jaouen <michel.jaouen@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@st-ericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/ab8500: support AB9540 variant
Message-ID: <20120201113154.GA13723@sirena.org.uk>
References: <1328094155-3320-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328094155-3320-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: The future lies ahead.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 12:02:35PM +0100, Linus Walleij wrote:

> identifier field. If possible, we fall back on auto-detecting
> the AB variant. The necessary deviations are factored into
> the driver and board data.

This seems a bit weird - I would expect the silicon to be more accurate
than user provided platform data.  I'd expect the driver to always check
the information provided by the device and at least log if there's a
difference.

It'd also be easier to review the patch if there was some description of
the differences (or there were a series of patches adding
parameterisation for relevant things followed by one adding the new
device).
