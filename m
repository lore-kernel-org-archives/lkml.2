Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1DRL7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:59:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51370 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1DRL7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:59:16 -0400
Date: Mon, 18 Apr 2011 12:59:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110418115903.GB9462@sirena.org.uk>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com> <20110418091902.13345132@lxorguk.ukuu.org.uk> <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
X-Cookie: APL hackers do it in the quad.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 06:50:12PM +1000, Ben Nizette wrote:

Please fix your MUA to word wrap within paragraphs; I've reflowed your
text for legibility.

> Still my question stands, where is the driver ever better placed to
> make these calls than the board code?

Even if it ends up being the board code using these APIs it seems
sensible to have a standard API that GPIO drivers can use to expose the
functionality.  This will help with getting control into code Linux owns
(since people don't have to implement custom APIs) and will mean we can
do things like add control of this for device tree based boards.
