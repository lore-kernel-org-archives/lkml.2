Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2LUNx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:53:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2586 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2LUNxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:53:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 21 Dec 2012 05:51:30 -0800
Message-ID: <50D46AE4.8020308@nvidia.com>
Date: Fri, 21 Dec 2012 15:57:56 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <1356097818.1490.109.camel@tellur>
In-Reply-To: <1356097818.1490.109.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.12.2012 15:50, Lucas Stach wrote:
> This has to be resolved before merging. Personally I'm in favour of
> keeping reg access patterns close to what is done in other parts of the
> kernel.

I haven't so far received comments from too many people, so that's why I
left it as is.

>>  * Uses still CMA helpers. IOMMU support will replace CMA with host1x
>>    specific allocator.
> 
> I really want the allocator issue resolved before talking about merging
> those patches. Proper IOMMU support will require a bit of rework of the
> current upstream IOMMU API, so it will still be a bit out.
> 
> But if you don't mind I'll try to implement the host1x allocator over
> the holidays and provide an incremental patch.

Do you mean host1x CMA allocator using dma mapping API? That'd be great
if you could help out. I've just tried to concentrate on getting ok for
base essentials before doing any extra work.

Terje

