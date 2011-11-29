Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1K2Kqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:46:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56252 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1K2Kqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:46:38 -0500
Date: Tue, 29 Nov 2011 10:46:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] gpiolib: Add decode of WM8994 GPIO configuration
Message-ID: <20111129104635.GA12111@sirena.org.uk>
References: <1322503501-26947-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdb-5N0nOCCozNX9kOq8xhz5O+2JR5s7j_fkFfh3SU-AqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb-5N0nOCCozNX9kOq8xhz5O+2JR5s7j_fkFfh3SU-AqA@mail.gmail.com>
X-Cookie: Justice, n.:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:31:18AM +0100, Linus Walleij wrote:
> On Mon, Nov 28, 2011 at 7:05 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:

> "gpiolib: Add decode of WM8994 GPIO configuration"

> Nitpicky: I would write "gpio/wm8994: add decode of gpio configuration" but
> that's up to you.

The brief survey of changelogs have "gpiolib".

> Perhaps some commit blurb about the niceness of decoding stuff here?

I'm not sure that really adds anything; I think the concept of decoding
things into human readable text is standard enough.
