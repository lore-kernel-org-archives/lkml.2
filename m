Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab2DJIcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:32:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60343 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab2DJIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:32:08 -0400
Date: Tue, 10 Apr 2012 09:31:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120410083130.GK24211@n2100.arm.linux.org.uk>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20120406074942.GO7264@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120406074942.GO7264@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 03:49:45PM +0800, Shawn Guo wrote:
> I believe this patch fixes the amba probe failure that impacts any
> AMBA platform build with CONFIG_REGULATOR enabled.  Could you consider
> to send the fix for -rc soon?

No idea.  I don't have Mark's patch in the patch system.

> The patch "ARM: amba: adapt to regulator probe deferral change" from
> me could be ignored now.

But I do have yours in there.  And what do I do with your other patch
in there touching this same area as well?

Please, sort it out between you and once the patch system is right, let
me know.
