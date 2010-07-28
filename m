Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab0G1N0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:26:22 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34237 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752411Ab0G1N0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:26:18 -0400
Date: Wed, 28 Jul 2010 15:26:08 +0200
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
Message-ID: <20100728132607.GA16737@ucw.cz>
References: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This bus driver supports the Single-wire Serial Bus Interface (SSBI)
> controller in the Qualcomm MSM SOCs.  SSBI is not an I2C but is
> functionally related enough such that it is able to leaverage the I2C
> framework.
> 
> Unlike I2C, SSBI is a point-to-point connection, and therefore there is no
> need to specify a slave device address. The SSBI implementation
> overrides the slave device address to be a device register address

Then perhaps it should not go to drivers/i2c? 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
