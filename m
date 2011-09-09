Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab1IIQL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:11:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42645 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752989Ab1IIQL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:11:57 -0400
Date: Fri, 9 Sep 2011 09:11:52 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, Mans Rullgard <mans.rullgard@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
 drivers
Message-ID: <20110909161151.GA3515@opensource.wolfsonmicro.com>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org>
 <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com>
 <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
 <3110288.bQbb0H2ME1@wuerfel>
 <1315520956.4126.3.camel@finisterre.wolfsonmicro.main>
 <20110908223720.GA21469@n2100.arm.linux.org.uk>
 <20110908224731.GB5201@opensource.wolfsonmicro.com>
 <20110908230102.GB21469@n2100.arm.linux.org.uk>
 <20110908235903.GA6370@opensource.wolfsonmicro.com>
 <20110909094156.GE6918@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909094156.GE6918@n2100.arm.linux.org.uk>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:41:56AM +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 08, 2011 at 04:59:04PM -0700, Mark Brown wrote:

> > The problem is that someone has to manually go and add the device to
> > every board that needs one and people find that tedious and slightly
> > inelegant

> Sheesh.  So now you're arguing against your statement above?  Please
> stop wasting my time.

There's two things going on here - what we are doing and what people
would like to be able to do.  What we are doing is explicitly adding
devices, what people would like to do is infer the devices from the
board type.  Personally I'm totally happy with explicitly adding an
audio device, but not everyone is and I do understand where they're
coming from.
