Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1IHXWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:22:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49815 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753892Ab1IHXWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:22:09 -0400
Date: Thu, 8 Sep 2011 09:13:42 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mans Rullgard <mans.rullgard@linaro.org>
Cc: linux-omap@vger.kernel.org, linaro-dev@lists.linaro.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jarkko Nikula <jhnikula@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: omap: convert per-board modules to platform drivers
Message-ID: <20110908161341.GA3098@opensource.wolfsonmicro.com>
References: <1315494354-17597-1-git-send-email-mans.rullgard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315494354-17597-1-git-send-email-mans.rullgard@linaro.org>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 04:05:53PM +0100, Mans Rullgard wrote:

> +static struct platform_device omap_soc_audio = {
> +	.name	= "omap-soc-audio",
> +	.id	= -1,
> +};
> +

This isn't really accomplishing anything as you're using the same device
name for all boards, it's essentially the same thing as soc-audio just
an OMAP version of that device.  Each machine driver should be a
separate platform driver.
