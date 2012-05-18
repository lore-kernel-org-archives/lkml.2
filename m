Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966381Ab2ERAKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:10:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57658 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965781Ab2ERAKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:10:47 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] gpiolib: Implement devm_gpio_request_one()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20120512190501.GB11435@sirena.org.uk>
References: <1335959206-8138-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1335959206-8138-2-git-send-email-broonie@opensource.wolfsonmicro.com> <20120512190501.GB11435@sirena.org.uk>
Date: Thu, 17 May 2012 18:10:45 -0600
Message-Id: <20120518001045.259CA3E062C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2012 20:05:02 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 02, 2012 at 12:46:46PM +0100, Mark Brown wrote:
> > Allow drivers to use the modern request and configure idiom together
> > with devres.
> 
> > As with plain gpio_request() and gpio_request_one() we can't implement
> > the old school version in terms of _one() as this would force the
> > explicit selection of a direction in gpio_request() which could break
> > systems if we pick the wrong one.  Implementing devm_gpio_request_one()
> > in terms of devm_gpio_request() would needlessly complicate things or
> > lead to duplication from the unmanaged version depending on how it's
> > done.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Any chance we can get this into 3.5?  Writing error handling code is
> boring :)

Applied, thanks.  I'll push it out this evening.

g.


-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
