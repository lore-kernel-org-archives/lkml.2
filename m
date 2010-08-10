Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab0HJVlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:41:21 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40575 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932367Ab0HJVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:41:18 -0400
Date: Tue, 10 Aug 2010 23:41:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: khali@linux-fr.org, ben-linux@fluff.org, linux-arm-msm@vger.kernel.org,
        sdharia@codeaurora.org, Crane Cai <crane.cai@amd.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Single-wire Serial Bus Interface for Qualcomm MSM
 chipsets
Message-ID: <20100810214111.GA28968@elf.ucw.cz>
References: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org>
 <20100728132607.GA16737@ucw.cz>
 <4C60B8BB.2050209@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C60B8BB.2050209@codeaurora.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>This bus driver supports the Single-wire Serial Bus Interface (SSBI)
> >>controller in the Qualcomm MSM SOCs.  SSBI is not an I2C but is
> >>functionally related enough such that it is able to leaverage the I2C
> >>framework.
> >>
> >>Unlike I2C, SSBI is a point-to-point connection, and therefore there is no
> >>need to specify a slave device address. The SSBI implementation
> >>overrides the slave device address to be a device register address
> >
> >Then perhaps it should not go to drivers/i2c?
> 
> I'd like to make use of the i2c framework rather than implement
> something else.  Are you suggesting that the driver reside elsewhere
> (i.e. mach-msm) or that the driver not use the i2c framework?

I believe it should go elsewere at the very least. drivers/ssbi ?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
