Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0G2IrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:47:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:54658 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab0G2IrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:47:22 -0400
Date: Thu, 29 Jul 2010 17:46:59 +0900
To: Joerg.Roedel@amd.com
Cc: arnd@arndb.de, fujita.tomonori@lab.ntt.co.jp, stepanm@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100729084018.GM26098@amd.com>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
	<201007291026.55928.arnd@arndb.de>
	<20100729084018.GM26098@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 17:47:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 10:40:19 +0200
"Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:

> The IOMMU-API is not about SR-IOV.

That's true. However, the point is that include/iommu.h is far from
the IOMMU-API.

You could still insist that include/iommu.h is designed for the
generic IOMMU-API. But the fact is that it's designed for very
specific purposes. No intention to make it for generic purposes.

Since you added it two years ago, nobody has tried to extend
it. Instead, we have something like
arch/arm/plat-omap/include/plat/iommu.h.
