Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0G2JPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:15:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:37283 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0G2JPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:15:09 -0400
Date: Thu, 29 Jul 2010 18:14:49 +0900
To: Joerg.Roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, stepanm@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100729090607.GN26098@amd.com>
References: <20100729084018.GM26098@amd.com>
	<20100729174621W.fujita.tomonori@lab.ntt.co.jp>
	<20100729090607.GN26098@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100729181412H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 18:14:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 11:06:08 +0200
"Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:

> On Thu, Jul 29, 2010 at 04:46:59AM -0400, FUJITA Tomonori wrote:
> > On Thu, 29 Jul 2010 10:40:19 +0200
> > "Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:
> > 
> > > The IOMMU-API is not about SR-IOV.
> > 
> > That's true. However, the point is that include/iommu.h is far from
> > the IOMMU-API.
> > 
> > You could still insist that include/iommu.h is designed for the
> > generic IOMMU-API. But the fact is that it's designed for very
> > specific purposes. No intention to make it for generic purposes.
> 
> I have no clue about the ARM iommus on the omap-platform. From a quick
> look into the header file I see some similarities to the IOMMU-API. I am

ARM's iommu stuff might be more appropriate as the IOMMU-API than
include/linux/iommu.h


> also very open for discussions about how the IOMMU-API could be extended
> to fit the needs of other platforms. Only because nobody has tried to
> discuss about such an effort is no reason to push the IOMMU-API back.

Well, the reason (nobody has tried) might be that linux/iommu.h
doesn't look something intended for the generic IOMMU-API.
