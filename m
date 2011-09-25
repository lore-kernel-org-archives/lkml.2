Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1IYEKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 00:10:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56326 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1IYEKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 00:10:12 -0400
Date: Sat, 24 Sep 2011 22:10:08 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v2 0/7] Add a generic struct clk
Message-ID: <20110925041008.GQ24631@ponder.secretlab.ca>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316730422-20027-1-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 03:26:55PM -0700, Mike Turquette wrote:
> Hi all,
> 
> The goal of this series is to provide a cross-platform clock framework
> that platforms can use to model their clock trees and perform common
> operations on them.  Currently everyone re-invents their own clock tree
> inside platform code which makes it impossible for drivers to use the
> clock APIs safely across many platforms and for distro's to compile
> multi-platform kernels which all redefine struct clk and its operations.
> 
> This is the second version of the common clock patches which were
> originally posted by Jeremy Kerr and then re-posted with some additional
> patches by Mark Brown.  Mark's re-post didn't have any changes done to
> the original four patches from Jeremy which is why this series is "v2".
> 
> The changes in this series are minimal: I've folded in some of Mark's
> fixes and most of the comments posted to his series as well as rebasing
> on top of v3.1-rc7.  The design and functionality hasn't changed much
> since Jeremy posted v1 of this series.  Propagating the rate change up
> to the parent has been removed from clk_set_rate since that needs some
> more thought.  I also dropped Mark's change to append a device's name to
> a clk name since device tree might solve this neatly.  Again more
> discussion around that would be good.
> 
> v1 of the series can be found at,
> http://article.gmane.org/gmane.linux.kernel/1143182
> 
> Mark's re-post (v1+) can be found at,
> http://article.gmane.org/gmane.linux.ports.arm.kernel/129889

Looks good at first review to me.  I had a few comments, but nothing
major.  It really needs some documentation though.

g.

