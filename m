Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1AKLSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:18:06 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60405 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab1AKLSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:18:01 -0500
Date: Tue, 11 Jan 2011 11:17:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.38
Message-ID: <20110111111758.GH6541@sirena.org.uk>
References: <20110110222145.31c40d8e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110222145.31c40d8e@endymion.delvare>
X-Cookie: An apple a day makes 365 apples a year.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:21:45PM +0100, Jean Delvare wrote:
> Hi Linus,
> 
> Please pull i2c subsystem updates for Linux 2.6.37 from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus
> 
> Not much this time around... Only the new generic I2C multiplexer using
> the GPIO API is worth mentioning.

It'd be good to also get the conversion to use the pm_generic_ stuff in
- that ends up fixing some bugs with the interaction between runtime and
system suspend and at least means that it's no longer the responsibility
of the I2C code to sort them out in future.  Linus merged the PM tree
bits for that already.
