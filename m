Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1LFQSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:18:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54931 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1LFQSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:18:23 -0500
Date: Tue, 6 Dec 2011 16:18:15 +0000
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
Message-ID: <20111206161815.GD13769@linaro.org>
References: <20111206151541.GA13774@linaro.org>
 <1321961573-4562-1-git-send-email-dave.martin@linaro.org>
 <20111206155911.GA11902@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206155911.GA11902@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 04:59:11PM +0100, Alessandro Rubini wrote:
> > ... it looks like Alessandro's proposed change to tidy up scripts/mod/
> > ile2alias.c may get merged soon
> 
> No, I don't think it will happen. Rusty disagrees, and his own
> suggestion is in the queue. I'm waiting a while to understand
> what is happening.
> 
> Anyways, I think it's better for me to wait for amba to come in, and
> work on scripts/mod later on. After all, it's meant to ease adding new
> buses later, not to make it more difficult for already scheduled ones.

OK -- thanks for the clarification.


Russell, it sounds like you shouldn't get a merge conflict with the
original version of the series after all.

For reference, the original pull request is here:

http://lists.infradead.org/pipermail/linux-arm-kernel/2011-November/073619.html


Cheers
---Dave
