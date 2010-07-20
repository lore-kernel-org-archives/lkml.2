Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227Ab0GTKLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:11:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:42724 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761205Ab0GTKLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:11:02 -0400
Date: Tue, 20 Jul 2010 19:09:31 +0900
To: linux@arm.linux.org.uk
Cc: zpfeffer@codeaurora.org, fujita.tomonori@lab.ntt.co.jp,
        ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
	memory management
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100719082213.GA7421@n2100.arm.linux.org.uk>
References: <20100715080710T.fujita.tomonori@lab.ntt.co.jp>
	<20100715014148.GC2239@codeaurora.org>
	<20100719082213.GA7421@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100720190904N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 20 Jul 2010 19:09:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 09:22:13 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > If I want to share the buffer with another device I have to
> > make a copy of the entire thing then fix up the virtual mappings for
> > the other device I'm sharing with.
> 
> This is something the DMA API doesn't do - probably because there hasn't
> been a requirement for it.
> 
> One of the issues for drivers is that by separating the mapped scatterlist
> from the input buffer scatterlist, it creates something else for them to
> allocate, which causes an additional failure point - and as all users sit
> well with the current API, there's little reason to change especially
> given the number of drivers which would need to be updated.

Agreed. There was the discussion about separating 'dma_addr and dma_len' from
scatterlist struct but I don't think that it's worth doing so.


> I'm just proving that it's not as hard as you seem to be making out.

Agreed again.
