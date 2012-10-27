Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2J0QOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:14:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54243 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2J0QOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:14:17 -0400
MIME-Version: 1.0
In-Reply-To: <201210261116.01507.poeschel@lemonage.de>
References: <20120925085559.GL28670@sortiz-mobl>
	<201210251802.42349.poeschel@lemonage.de>
	<20121025160651.GO18814@opensource.wolfsonmicro.com>
	<201210261116.01507.poeschel@lemonage.de>
Date: Sat, 27 Oct 2012 18:14:16 +0200
Message-ID: <CACRpkdbwgjfyggEdNXJ=gdjBegU3GghuzEORC07fq0yTzJYbJA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:16 AM, Lars Poeschel <poeschel@lemonage.de> wrote:

> I am a bit unsure what to do now. Since Linus said he would take my driver
> without regmap, this will be my way for the driver.

Please submit the code in the shape you want me to merge it.

I think you've done an honest effort (more than most would do for sure)
to explore the ways of the regmap. If it doesn't fit, it doesn't fit and
that's it.

Yours,
Linus Walleij
