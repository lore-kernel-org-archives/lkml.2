Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab1IIQP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:15:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42677 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754958Ab1IIQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:15:55 -0400
Date: Fri, 9 Sep 2011 09:15:52 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mans Rullgard <mans.rullgard@linaro.org>
Cc: linux-omap@vger.kernel.org, linaro-dev@lists.linaro.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jarkko Nikula <jhnikula@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v3] ASoC: omap: convert per-board modules to platform
 drivers
Message-ID: <20110909161551.GC3515@opensource.wolfsonmicro.com>
References: <1315568332-10224-1-git-send-email-mans.rullgard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315568332-10224-1-git-send-email-mans.rullgard@linaro.org>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 12:38:51PM +0100, Mans Rullgard wrote:
> This converts the per-board modules to platform drivers for a
> device created by in main platform setup.  These drivers call
> snd_soc_register_card() directly instead of going via a "soc-audio"
> device and the corresponding driver in soc-core.
> 
> Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
