Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2ELTbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:31:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2ELTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:31:53 -0400
Date: Sat, 12 May 2012 21:31:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Thomas Abraham <thomas.abraham@linaro.org>
cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/7] mmc: dw_mmc: add device tree support
In-Reply-To: <CAJuYYwQj7gzZ9piJAJLcf7SiyJnQ6nZ63-X9ieQ-FCj6TNhQPQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1205122117340.11826@axis700.grange>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
 <1335935266-25289-4-git-send-email-thomas.abraham@linaro.org>
 <Pine.LNX.4.64.1205040047280.18111@axis700.grange>
 <CAJuYYwQj7gzZ9piJAJLcf7SiyJnQ6nZ63-X9ieQ-FCj6TNhQPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:tLEpOd/49ZqeSRMtbNKPekR+AJJQVOwn+ixGdqpAj7c
 2oSMSlmE2T5Bqg7MRc8OSKFeEUiecHVhfm7lziHrBdq8AfrBcr
 4QufZ1WXDq460eveGIbsGJ+WxHjf5GwXRBj2Ij4999gH2UsHHa
 CMP6vz7FvD7rANI9lGwgWaMBY4VyLoorAIbMFOzjJ2fiUq8wny
 GCH6YFDwaIYLK3+1xt2003F1gwvNZqHaW/ZBt4aXlvliCBJRBL
 6p8hSrfHaTcrbUJpYQ37QmCURMvrxqSUQAICWm7F+pMqK77ZBh
 YCVcvCZarZ2B3zBnwiaOgT3TmnUUY3qeNA1QNQM1juTK1B+Ltt
 /tBqYsulPmh7JaLXkr19bAqUpCREDR/zj2fzodAvPM7k0VKDx5
 yjPl8cxBM4QuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

On Sat, 12 May 2012, Thomas Abraham wrote:

> On 4 May 2012 04:18, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >
> > What do you think about this patch
> >
> > http://www.spinics.net/lists/linux-sh/msg11259.html
> >
> > and about using mmc-generic OF properties instead of creating yet another
> > copy of proprietary ones?
> 
> Hi Guennadi,
> 
> This patch does not intend to add any custom mmc properties. I checked
> your patch (in the link mentioned above) and most of the bindings are
> similar to what you have come up with except for the "ro-gpios" for
> which I have used "wp-gpios". But this is following what Arnd had
> proposed here: http://www.spinics.net/lists/linux-mmc/msg13564.html.

Thanks for the link! I didn't know about that patch.

> Regarding the MMC_CAP_4_BIT_DATA and MMC_CAP_8_BIT_DATA in your patch,
> these can be derived from the bus width information that the driver
> receives.

Sure. I think, my patch, that I mentioned above, shall be dropped, at 
least in its present form. But if at least in principle we do want to have 
a common MMC OF parser for common bindings, some code from your patch 
would become redundant, I think. BTW, isn't this

+	gpio = of_get_named_gpio(np, "wp_gpios", 0);

a typo? Shouldn't it be "wp-gpios" instead?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
