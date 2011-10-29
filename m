Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab1J2RmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:42:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51897 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933496Ab1J2RmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:42:05 -0400
Date: Sat, 29 Oct 2011 18:42:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
        linux-omap@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] regulator: Provide dummy supply support
Message-ID: <20111029174202.GA9646@opensource.wolfsonmicro.com>
References: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de> <1319833618-25190-2-git-send-email-s.hauer@pengutronix.de> <20111028215931.GA30366@opensource.wolfsonmicro.com> <20111028224757.GG23421@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028224757.GG23421@pengutronix.de>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 12:47:57AM +0200, Sascha Hauer wrote:

> My main concern with the fixed regulator is that it needs quite much
> boilerplate code just to say that we have no regulator at all for a
> given device. That could also be handled with a helper function which
> registers a fixed regulator and only takes the regulator_consumer_supply
> as an argument. Would that be ok for you?

All you're actually doing in this code is adding a function to register
a new type of regulator which is exactly equivalent to what the existing
regulators provide - there's nothing particularly wrong with the helper
function but defining an entirely new regulator type for it doesn't seem
useful.
