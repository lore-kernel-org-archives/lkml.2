Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab2FZB4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:56:08 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:36352 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757862Ab2FZB4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:56:06 -0400
Date: Mon, 25 Jun 2012 18:55:51 -0700
From: Mike Turquette <mturquette@ti.com>
To: sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: linux-next: adding the common clk tree
Message-ID: <20120626015551.GW4402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Would you please add the clk-next branch of the common clock tree to
linux-next?

git://git.linaro.org/people/mturquette/linux.git clk-next

Thanks much!

For all of those Cc'd, I just wanted to say that I'm changing the way I
manage clk-next.  The clk-next branch now WILL be rebased, and it's only
purpose is to make it easy to test things in linux-next.  You can base
work on it, but be prepare for breakage and shifting commit ids.

If you don't want breakage and shifting commit ids then you might want
to use my clk-fixes branch (stable) and my clk-3.x branch (stable).  As
patches go through the linux-next cycle and appear stable I'll migrate
them over to clk-3.x which won't ever be rebased.  This is the branch
I'll send to Linus.  clk-next is simply comprised of merging clk-fixes,
clk-3.x and whatever unstable patches I have laying around.

Regards,
Mike
