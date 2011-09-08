Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1IHXMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:12:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35073 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751879Ab1IHXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:12:08 -0400
Date: Thu, 8 Sep 2011 09:37:43 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mans Rullgard <mans.rullgard@linaro.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, linaro-dev@lists.linaro.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH] ASoC: omap: convert per-board modules to
 platform drivers
Message-ID: <20110908163742.GD3098@opensource.wolfsonmicro.com>
References: <1315494354-17597-1-git-send-email-mans.rullgard@linaro.org>
 <4E68DBF7.1030009@metafoo.de>
 <CAG5Tg6XxGP1YhQ0zW3f=1EkZfAmb9vj3pBemeSazpH1_CZ3OzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG5Tg6XxGP1YhQ0zW3f=1EkZfAmb9vj3pBemeSazpH1_CZ3OzQ@mail.gmail.com>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 04:41:30PM +0100, Mans Rullgard wrote:
> On 8 September 2011 16:15, Lars-Peter Clausen <lars@metafoo.de> wrote:

> > Use different device driver names for different drivers.

> I guess this worked by accident on my system.

> Are there any other changes needed?

Check the N810 code - it looks like that driver should be taking
platform data to distinguish between the two models.  Possibly also rx51
though I only looked at the diff.  Also it should probably be grabbing
the clocks before it registers the card.
