Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab1IJVnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 17:43:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46755 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933810Ab1IJVnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 17:43:46 -0400
Date: Sat, 10 Sep 2011 22:43:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, Mans Rullgard <mans.rullgard@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
	drivers
Message-ID: <20110910214343.GB21361@opensource.wolfsonmicro.com>
References: <3110288.bQbb0H2ME1@wuerfel> <20110909193010.GA2993@opensource.wolfsonmicro.com> <20110909205645.GA16355@n2100.arm.linux.org.uk> <201109102237.15193.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109102237.15193.arnd@arndb.de>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 10:37:15PM +0200, Arnd Bergmann wrote:
> On Friday 09 September 2011, Russell King - ARM Linux wrote:

> > That's just twisted and utterly insane - adding more code for precisely
> > zero benefit what so ever.  Think about it - the device tree is already
> > creating platform devices for entries in the device tree file.  What's

> Exactly. No driver or (worse) user program should ever need to look at
> the top-level compatible property. When you want information about a
> localized part of the system (e.g. the ASoC components), you should
> look up the information for that component.

Right, and this is the state of the art right now.  I can see why people
find this inelegant and want to come up with a way of automatically
generating all these different devices to describe boards especially
with the non-device tree systems, though, so if people want to work on
that stuff I don't see a problem with it.
