Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab1IUN4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:56:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60225 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750711Ab1IUN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:56:12 -0400
Date: Wed, 21 Sep 2011 14:56:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cliff Cai <Cliff.Cai@analog.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/4] ASoC: Staticise bf5xx_pcm_ac97_new()
Message-ID: <20110921135609.GJ4374@opensource.wolfsonmicro.com>
References: <1316587205.2824.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316587205.2824.1.camel@phoenix>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 02:40:05PM +0800, Axel Lin wrote:
> It is not used outside this driver so no need to make the symbol global.

All applied, thanks.
