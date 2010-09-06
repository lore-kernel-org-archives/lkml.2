Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab0IFJol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:44:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50752 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750790Ab0IFJok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:44:40 -0400
Date: Mon, 6 Sep 2010 10:44:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: wm831x-ldo - fix the logic to set
 REGULATOR_MODE_IDLE and REGULATOR_MODE_STANDBY modes
Message-ID: <20100906094437.GB10367@rakim.wolfsonmicro.main>
References: <1283762893.10643.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283762893.10643.2.camel@mola>
X-Cookie: Welcome to the Zoo!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 04:48:13PM +0800, Axel Lin wrote:
> Problem description in current implementation:
> When setting REGULATOR_MODE_IDLE mode, current implementation set
> WM831X_LDO1_LP_MODE bit of ctrl_reg (which is wrong, it should clear the bit).

Again, it would be really helpful if you could make your analysis
clearer - at no point do you explain why you think the chip settings
that result from your changes are correct.  Your message explains that
the status readback differs from the settings but it doesn't explain how
you know which bit of code is correct.  This means that your messages
set off alarm bells as it looks like you're just guessing about what
needs to be done to the chip.

In this case your patch appears to be OK so:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
