Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2LCGWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:22:54 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12257 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LCGWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:22:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 02 Dec 2012 22:22:17 -0800
Message-ID: <50BC4624.4050707@nvidia.com>
Date: Mon, 3 Dec 2012 08:26:44 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B7AB93.5060207@wwwdotorg.org> <1354265429.1479.187.camel@tellur> <50B9EDA9.2000500@nvidia.com> <20121201151020.GC18209@avionic-0098.adnet.avionic-design.de> <50BA3668.1010504@nvidia.com> <1354383291.1503.25.camel@tellur> <50BA5AB2.8000604@nvidia.com> <CAPM=9tzUYkMZhwReSDLxvMYvgDmXukajm8EMqtzqmcNeD+oMAw@mail.gmail.com> <50BB3A5D.6070304@nvidia.com> <20121202205527.GA22086@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121202205527.GA22086@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.12.2012 22:55, Thierry Reding wrote:
> FWIW I'm convinced that you're genuinely trying to make this work and
> nobody welcomes this more than me. However it is only natural if you
> dump such a large body of code on the community that people will
> disagree with some of the design decisions.
> 
> So when I comment on the design or patches in general, it is not my
> intention to exclude you or NVIDIA in any way. All I'm trying to do is
> spot problematic or unclear parts that will make working with the code
> any more difficult than it has to be.

Thanks, I know it'a a large dump and you've made great comments about
the code, and hit most of the sore spots I've had with the driver, too.
I appreciate your effort - this process is making the driver better.

It's good to hear that our goals are aligned. So now that we got that
out of the system, let's get back to business. :-)

> Since tegra-drm is a DRM driver it should stay in drivers/gpu/drm. I can
> also live with the host1x driver staying in drivers/video, but I don't
> think it's the proper location and drivers/gpu/host1x seems like a much
> better fit.

That sounds like a plan to me.

Terje
