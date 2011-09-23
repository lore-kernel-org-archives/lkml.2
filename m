Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1IWKyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:54:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54162 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752726Ab1IWKye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:54:34 -0400
Date: Fri, 23 Sep 2011 11:54:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Remove unneeded mutex_init in wl1273_probe()
Message-ID: <20110923105432.GF3165@opensource.wolfsonmicro.com>
References: <1316754658.3012.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316754658.3012.3.camel@phoenix>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 01:10:57PM +0800, Axel Lin wrote:
> Since f0fba2ad "ASoC: multi-component - ASoC Multi-Component Support",
> snd_soc_register_codec() now does all the codec list and mutex init.
> Thus don't need to call mutex_init(&codec->mutex) in wl1273_probe() any more.

Applied, thanks.
