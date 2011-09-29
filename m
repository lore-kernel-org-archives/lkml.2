Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab1I2Syj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:54:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38243 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab1I2Syi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:54:38 -0400
Date: Thu, 29 Sep 2011 19:54:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, skannan@quicinc.com,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 0/7] Add a generic struct clk
Message-ID: <20110929185432.GD2085@sirena.org.uk>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316730422-20027-1-git-send-email-mturquette@ti.com>
X-Cookie: Whip it, whip it good!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 03:26:55PM -0700, Mike Turquette wrote:

> more thought.  I also dropped Mark's change to append a device's name to
> a clk name since device tree might solve this neatly.  Again more
> discussion around that would be good.

Some of that was for debugfs type stuff - if we end up providing
information about the clocks via a diagnostic interface being able to
distinguish between things in a textual fashion would be handy (and I'd
guess the struct device may also be needed by any OF bindings to get at
the bindings?).
