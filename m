Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2LBLY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 06:24:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2432 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2LBLY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 06:24:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 02 Dec 2012 03:23:41 -0800
Message-ID: <50BB3A5D.6070304@nvidia.com>
Date: Sun, 2 Dec 2012 13:24:13 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: Lucas Stach <dev@lynxeye.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B7AB93.5060207@wwwdotorg.org>	<1354265429.1479.187.camel@tellur> <50B9EDA9.2000500@nvidia.com> <20121201151020.GC18209@avionic-0098.adnet.avionic-design.de> <50BA3668.1010504@nvidia.com>	<1354383291.1503.25.camel@tellur> <50BA5AB2.8000604@nvidia.com> <CAPM=9tzUYkMZhwReSDLxvMYvgDmXukajm8EMqtzqmcNeD+oMAw@mail.gmail.com>
In-Reply-To: <CAPM=9tzUYkMZhwReSDLxvMYvgDmXukajm8EMqtzqmcNeD+oMAw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2012 23:42, Dave Airlie wrote:
> Guys I think you guys might be overthniking things here.
> 
> I know you have some sort of upstream/downstream split, but really in
> the upstream kernel, we don't care about that, so don't make it our
> problem.

I am not trying to make anything your problem. Most of the issues we
have already worked out with a good solution that all active
participants have agreed with. We have only a couple of disagreements
with Thierry.

My goal is to get a good open source co-operation and trying to prevent
a code fork while still maintaining good design. That way everybody
wins. The way to do that is to base our BSP on upstream kernel.

I'm not trying to here throw code over the fence and flee. This is a
genuine attempt to work together. I want to prevent the "we" (kernel
community excluding NVIDIA) and "you" (NVIDIA) that a split code base
would cause in the long run. I'd like to just talk about "we" including
NVIDIA.

> There is no need for any sort of stable API between host1x and the sub
> drivers, we change APIs in the kernel the whole time it isn't a
> problem.
> 
> If you need to change the API, submit a single patch changing it
> across all the drivers in the tree, collecting Acks or not as needed.
> We do this the whole time, I've never had or seen a problem with it.
> 
> We don't do separate subsystems APIs set in stone bullshit, and all
> subsystem maintainers are used to dealing with these sort of issues.
> You get an ack from one maintainer and the other one sticks it in his
> tree with a note to Linus.
> 
> You can put the code where you want, maybe just under drivers/gpu
> instead of drivers/video or drivers/gpu/drm, just make sure you have a
> path for it into the kernel.

Follows exactly my thinking, as the location of host1x driver has no
practical consequence to me.

Thierry proposed drivers/gpu/host1x. I'd like to see a couple of
comments on that proposal, and if it sticks, follow that.

Thierry, did you mean that host1x driver would be in drivers/gpu/host1x,
and tegradrm in drivers/gpu/drm/tegra, or would we put both in same
directory?

> And I have an non-upstream precedent for v4l sitting on drm, some
> radeon GPUs have capture tuners, and the only way to implement that
> would be to stick a v4l driver in the radeon drm driver. Not a
> problem, just never finished writing the code.

Yes, I just mentioned that as awkward, but I have no problem with any path.

Terje
