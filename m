Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1AKLZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:25:12 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:11846 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab1AKLZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:25:09 -0500
Date: Tue, 11 Jan 2011 12:25:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.38
Message-ID: <20110111122500.203c4ce4@endymion.delvare>
In-Reply-To: <20110111111758.GH6541@sirena.org.uk>
References: <20110110222145.31c40d8e@endymion.delvare>
	<20110111111758.GH6541@sirena.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, 11 Jan 2011 11:17:58 +0000, Mark Brown wrote:
> On Mon, Jan 10, 2011 at 10:21:45PM +0100, Jean Delvare wrote:
> > Hi Linus,
> > 
> > Please pull i2c subsystem updates for Linux 2.6.37 from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus
> > 
> > Not much this time around... Only the new generic I2C multiplexer using
> > the GPIO API is worth mentioning.
> 
> It'd be good to also get the conversion to use the pm_generic_ stuff in
> - that ends up fixing some bugs with the interaction between runtime and
> system suspend and at least means that it's no longer the responsibility
> of the I2C code to sort them out in future.  Linus merged the PM tree
> bits for that already.

Thanks for the reminder, I'll look into that as soon as possible and
when the patches are ready, I'll send another pull request to Linus.

-- 
Jean Delvare
