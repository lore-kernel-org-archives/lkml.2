Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1JVKJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:09:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47305 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060Ab1JVKJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:09:41 -0400
Date: Sat, 22 Oct 2011 11:09:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2] ASoC: max98095: Convert codec->hw_write to
 snd_soc_write
Message-ID: <20111022100939.GA3727@opensource.wolfsonmicro.com>
References: <1318650362.6399.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318650362.6399.1.camel@phoenix>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 11:46:02AM +0800, Axel Lin wrote:
> codec->hw_write is broken now, convert codec->hw_write to snd_soc_write.
> 
> The hardware has 2 banks of registers sharing a section in I2C register space.
> The 1st bank is the primary one and is cached.
> The 2nd bank is for loading coefficients only and they do not need cache.
> These coefficients registers are therefore direct writes.
> Thus we set cache_bypass flag to deal with this before calling snd_soc_write.

Applied, thanks.
