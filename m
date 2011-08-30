Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1H3TUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:20:35 -0400
Received: from void.printf.net ([89.145.121.20]:42087 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab1H3TUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:20:31 -0400
From: Chris Ball <cjb@laptop.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] arm/dt: Tegra: Update SDHCI nodes to match bindings
References: <1314731837-6985-1-git-send-email-swarren@nvidia.com>
Date: Tue, 30 Aug 2011 15:20:11 -0400
In-Reply-To: <1314731837-6985-1-git-send-email-swarren@nvidia.com> (Stephen
	Warren's message of "Tue, 30 Aug 2011 13:17:15 -0600")
Message-ID: <m2hb4yso44.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Aug 30 2011, Stephen Warren wrote:
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Olof Johansson <olof@lixom.net>
> ---
> This is a repost of http://www.spinics.net/lists/linux-tegra/msg02117.html
> I'm including it here since it's not in linux-next yet, and patch 3 depends
> on it.

I assume I should wait for patches 1+3 to appear in -next via another tree
before I merge patch 2 -- let me know if that's incorrect.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
