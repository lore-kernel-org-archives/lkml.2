Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1JLMKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:10:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45659 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab1JLMKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:10:47 -0400
Date: Wed, 12 Oct 2011 13:10:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Make SND_SOC_SAARB and SND_SOC_TAVOREVB3 depend on
 MFD_88PM860X
Message-ID: <20111012121045.GK3647@opensource.wolfsonmicro.com>
References: <1318420192.28832.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318420192.28832.1.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 07:49:52PM +0800, Axel Lin wrote:
> In saarb_pm860x_init() and evb3_pm860x_init(), we call
> pm860x_hs_jack_detect() and pm860x_mic_jack_detect() which in turn
> calls pm860x_set_bits().
> Thus make SND_SOC_SAARB and SND_SOC_TAVOREVB3 depend on MFD_88PM860X

What we just did for WM8994 was add a select of the MFD for consistency
with the way the CODEC driver itself is handled.
