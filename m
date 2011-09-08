Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1IHXHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:07:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49798 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751943Ab1IHXHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:07:09 -0400
Date: Thu, 8 Sep 2011 11:18:32 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Mans Rullgard <mans.rullgard@linaro.org>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
 drivers
Message-ID: <20110908181831.GE3591@opensource.wolfsonmicro.com>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org>
 <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 11:47:16PM +0530, Jassi Brar wrote:

> Can't we do by having omap_init_audio() in arch/arm/mach-omap2/devices.c
> generate a platform device of name depending upon machine_is_* ?

That's not a bad idea.  If we were going to do that it shouldn't be OMAP
specific, any platform could use it.  Though we'd need a way to override
it to provide platform data on systems that needs it.
