Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1EUOfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:35:23 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41254 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751928Ab1EUOfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:35:20 -0400
Date: Sat, 21 May 2011 16:35:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: Disable CF during suspend
Message-ID: <20110521143535.GA2422@elf.ucw.cz>
References: <20110521094326.GB26323@elf.ucw.cz>
 <1305988078.5824.14.camel@utx.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305988078.5824.14.camel@utx.lan>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Disable SPITZ_SCP_CF_POWER during suspend. Otherwise it eats battery,
> > fast. Thanks to Stanislav Brabec.
> 
> If you can verify that your card turns off on suspend, then you have my:
> Acked-by: Stanislav Brabec <utx@penguin.cz>

Yes, I checked the LEDs to make sure it is off. It is.

> But I would line to see more aggressive power control, something like
> spitz_card_pwr_ctrl() in old kernels - if there is no CF and no
> (external) CF card inserted, then SPITZ_SCP_CF_POWER card be turned off.
> If they are memory cards, they can be turned off even while idle.

Yes, that would be nice; but this is already good first step.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
