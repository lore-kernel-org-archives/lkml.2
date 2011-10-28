Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab1J1V5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:57:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36017 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172Ab1J1V5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:57:05 -0400
Date: Fri, 28 Oct 2011 23:57:03 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
        linux-omap@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] regulator: provide dummy supply support
Message-ID: <20111028215703.GB30339@opensource.wolfsonmicro.com>
References: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
X-Cookie: You fill a much-needed gap.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 10:26:57PM +0200, Sascha Hauer wrote:

> The following patch allows it for boards to register a dummy supply for
> devices for which no software controllable regulator is available. The
> current CONFIG_REGULATOR_DUMMY and (unused) regulator_use_dummy_regulator()

Please don't send cover letters for single patch serieses, if there's
content it should probably be in the changelog...
