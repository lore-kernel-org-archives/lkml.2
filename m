Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1JQVtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:49:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47707 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115Ab1JQVtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:49:42 -0400
Date: Mon, 17 Oct 2011 22:49:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] ASoC: wm8900: Fix wrong mask for setting
 DAC_CLKDIV/ADC_CLKDIV/LRCLK_MODE
Message-ID: <20111017214939.GJ5200@opensource.wolfsonmicro.com>
References: <1318778876.3106.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318778876.3106.3.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 11:27:55PM +0800, Axel Lin wrote:
> After checking the datasheet, I think what we want to do here is to
> clear the WM8900_REG_CLOCKING2_DAC_CLKDIV/WM8900_REG_CLOCKING2_ADC_CLKDIV/
> WM8900_REG_DACCTRL_AIF_LRCLKRATE bits and then OR with div value.

Applied all, thanks.
