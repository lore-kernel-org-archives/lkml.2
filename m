Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1ILLLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 07:11:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40131 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752776Ab1ILLLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 07:11:51 -0400
Date: Mon, 12 Sep 2011 12:11:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mans Rullgard <mans.rullgard@linaro.org>
Cc: linux-omap@vger.kernel.org, linaro-dev@lists.linaro.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jarkko Nikula <jhnikula@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v4] ASoC: omap: convert per-board modules to platform
 drivers
Message-ID: <20110912111149.GE2953@opensource.wolfsonmicro.com>
References: <1315738652-6278-1-git-send-email-mans.rullgard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315738652-6278-1-git-send-email-mans.rullgard@linaro.org>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 11:57:32AM +0100, Mans Rullgard wrote:
> This converts the per-board modules to platform drivers for a
> device created by in main platform setup.  These drivers call
> snd_soc_register_card() directly instead of going via a "soc-audio"
> device and the corresponding driver in soc-core.
> 
> Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
