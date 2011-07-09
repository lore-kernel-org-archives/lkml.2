Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1GIBet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 21:34:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35848 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1GIBes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 21:34:48 -0400
Date: Sat, 9 Jul 2011 02:34:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>, perex@perex.cz,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, tomoya-linux@dsn.okisemi.com
Subject: Re: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
Message-ID: <20110709013441.GB25165@sirena.org.uk>
References: <1309948067-9333-1-git-send-email-toshiharu-linux@dsn.okisemi.com> <s5hhb6z3byw.wl%tiwai@suse.de> <34CF59A8D33E40B6822498A23CD554E8@hacdom.okisemi.com> <s5hvcve1n40.wl%tiwai@suse.de> <A103B14DCBE64935815497A3464F512F@hacdom.okisemi.com> <s5h8vsa11x2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8vsa11x2.wl%tiwai@suse.de>
X-Cookie: Cole's Law:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 06:38:33PM +0200, Takashi Iwai wrote:

> It's not clear what you mean exactly as "unfixed", but in general, the
> decision rather depends on the usage of the device.  If it's designed
> for a use as a desktop PC component (such as a PCI card or
> onboard-audio on PC), it'd make sense to implement as a stand-alone,
> self-contained driver.

> OTOH, if it's targeted mainly for embedded area, ASoC is the right
> answer.  It's more modularized, and can be more flexibly configured in
> the end.

I'd say it depends rather more on the physical system design.  If there
are a bunch of separate chips which are interacted with separately by
software then ASoC makes sense, if the card is one logical object to
hardware a vanilla ALSA driver probably does.
