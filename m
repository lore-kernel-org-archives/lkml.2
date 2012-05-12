Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2ELTFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:05:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56258 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2ELTFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:05:04 -0400
Date: Sat, 12 May 2012 20:05:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gpiolib: Implement devm_gpio_request_one()
Message-ID: <20120512190501.GB11435@sirena.org.uk>
References: <1335959206-8138-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1335959206-8138-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335959206-8138-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: To err is human, to moo bovine.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 12:46:46PM +0100, Mark Brown wrote:
> Allow drivers to use the modern request and configure idiom together
> with devres.

> As with plain gpio_request() and gpio_request_one() we can't implement
> the old school version in terms of _one() as this would force the
> explicit selection of a direction in gpio_request() which could break
> systems if we pick the wrong one.  Implementing devm_gpio_request_one()
> in terms of devm_gpio_request() would needlessly complicate things or
> lead to duplication from the unmanaged version depending on how it's
> done.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Any chance we can get this into 3.5?  Writing error handling code is
boring :)
