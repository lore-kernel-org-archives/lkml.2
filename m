Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2K0L1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:27:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3481 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab2K0L1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:27:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 27 Nov 2012 03:27:26 -0800
Message-ID: <50B4A483.8030305@nvidia.com>
Date: Tue, 27 Nov 2012 13:31:15 +0200
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
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com> <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com> <50B46336.8030605@nvidia.com> <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com> <50B476E1.4070403@nvidia.com> <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com> <50B47DA8.60609@nvidia.com> <1354011776.1479.31.camel@tellur> <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2012 12:37, Thierry Reding wrote:
> But in that case it should be made mandatory at first until proper IOMMU
> support is enabled on Tegra30. Then it can be checked at driver probe
> time whether or not to enable the extra checks. That way we don't need a
> special Kconfig option and we still get all the security that we need,
> right?

I guess it depends on the level of security.

If we want to only protect kernel and user space memory, this would be
sufficient and no firewall is needed if IOMMU is turned on.

If we want to protect 2D buffers from each other, this is not sufficient.

Terje
