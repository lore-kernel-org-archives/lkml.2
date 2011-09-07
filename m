Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1IGRK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:10:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56920 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754359Ab1IGRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:10:55 -0400
Date: Wed, 7 Sep 2011 10:10:50 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mans Rullgard <mans.rullgard@linaro.org>
Cc: linux-omap@vger.kernel.org, linaro-dev@lists.linaro.org,
        Jarkko Nikula <jhnikula@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ASoC: omap: add MODULE_ALIAS to mcbsp and pcm drivers
Message-ID: <20110907171049.GA2906@opensource.wolfsonmicro.com>
References: <1315393641-21261-1-git-send-email-mans.rullgard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315393641-21261-1-git-send-email-mans.rullgard@linaro.org>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 12:07:21PM +0100, Mans Rullgard wrote:
> This adds MODULE_ALIAS directives to the omap-mcbsp-dai and
> omap-pcm-audio drivers so they can be auto-loaded when platform
> devices are scanned.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
