Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1LFQBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:01:20 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63618 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab1LFQBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:01:17 -0500
Date: Tue, 6 Dec 2011 16:59:11 +0100
From: Alessandro Rubini <rubini@unipv.it>
To: dave.martin@linaro.org
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
Message-ID: <20111206155911.GA11902@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20111206151541.GA13774@linaro.org>
References: <20111206151541.GA13774@linaro.org>
  <1321961573-4562-1-git-send-email-dave.martin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... it looks like Alessandro's proposed change to tidy up scripts/mod/
> ile2alias.c may get merged soon

No, I don't think it will happen. Rusty disagrees, and his own
suggestion is in the queue. I'm waiting a while to understand
what is happening.

Anyways, I think it's better for me to wait for amba to come in, and
work on scripts/mod later on. After all, it's meant to ease adding new
buses later, not to make it more difficult for already scheduled ones.

/alessandro
