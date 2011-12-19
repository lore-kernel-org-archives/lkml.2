Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1LSNYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:24:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37807 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1LSNYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:24:17 -0500
Date: Mon, 19 Dec 2011 13:24:09 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Alessandro Rubini <rubini@unipv.it>
Cc: linux@arm.linux.org.uk, patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        a.zummo@towertech.it, alsa-devel@alsa-project.org, cjb@laptop.org,
        dan.j.williams@intel.com, dmitry.torokhov@gmail.com,
        grant.likely@secretlab.ca, perex@perex.cz, jassisinghbrar@gmail.com,
        julia@diku.dk, linus.walleij@linaro.org, linux-fbdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-watchdog@vger.kernel.org,
        lethal@linux-sh.org, Pawel.Moll@arm.com, rtc-linux@googlegroups.com,
        spi-devel-general@lists.sourceforge.net, tiwai@suse.de,
        vinod.koul@intel.com, wim@iguana.be
Subject: Re: [GIT PULL] ARM: amba: Enable module alias autogeneration for
 AMBA drivers
Message-ID: <20111219132409.GB2031@linaro.org>
References: <20111206151541.GA13774@linaro.org>
 <1321961573-4562-1-git-send-email-dave.martin@linaro.org>
 <20111206155911.GA11902@mail.gnudd.com>
 <20111206161815.GD13769@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206161815.GD13769@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

This one isn't urgent, but I'm not seeing the amba modalias patches
anywhere yet.  Did you have any outstanding concerns which need to be
resolved?

If you can suggest when/if these are likely to merge that would be great.

Since Alessandro is now expecting to have to rebase on top of the amba
additions anyway, we shouldn't need to worry about conflicting with his
patches.

Of course, if you've already merged these somewhere, then there's no
problem.

Cheers
---Dave
