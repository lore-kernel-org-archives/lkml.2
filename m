Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab2K3Hkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:40:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19980 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2K3Hku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:40:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 29 Nov 2012 23:40:28 -0800
Message-ID: <50B863E4.50700@nvidia.com>
Date: Fri, 30 Nov 2012 09:44:36 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Lucas Stach <dev@lynxeye.de>, Dave Airlie <airlied@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur> <50B61845.6060102@nvidia.com> <1354111565.1479.73.camel@tellur> <50B6237B.8010808@nvidia.com> <1354115609.1479.91.camel@tellur> <50B63A70.8020107@nvidia.com> <1354128408.1479.137.camel@tellur> <50B71A28.5060807@nvidia.com> <1354180153.1479.162.camel@tellur> <20121129121430.GA3846@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121129121430.GA3846@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 14:14, Thierry Reding wrote:
> On Thu, Nov 29, 2012 at 10:09:13AM +0100, Lucas Stach wrote:
>> This way you would also be able to construct different handles (like GEM
>> obj or V4L2 buffers) from the same backing nvhost object. Note that I'm
>> not sure how useful this would be, but it seems like a reasonable design
>> to me being able to do so.
> 
> Wouldn't that be useful for sharing buffers between DRM and V4L2 using
> dma-buf? I'm not very familiar with how exactly importing and exporting
> work with dma-buf, so maybe I need to read up some more.

I would still preserve the dma-buf support, for exactly this purpose.

Terje

