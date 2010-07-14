Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0GNXI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:08:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:40947 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab0GNXIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:08:54 -0400
Date: Thu, 15 Jul 2010 08:07:28 +0900
To: zpfeffer@codeaurora.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux@arm.linux.org.uk,
        ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100714201149.GA14008@codeaurora.org>
References: <20100713121420.GB4263@codeaurora.org>
	<20100714104353B.fujita.tomonori@lab.ntt.co.jp>
	<20100714201149.GA14008@codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100715080710T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 15 Jul 2010 08:07:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 13:11:49 -0700
Zach Pfeffer <zpfeffer@codeaurora.org> wrote:

> On Wed, Jul 14, 2010 at 10:59:38AM +0900, FUJITA Tomonori wrote:
> > On Tue, 13 Jul 2010 05:14:21 -0700
> > Zach Pfeffer <zpfeffer@codeaurora.org> wrote:
> > 
> > > > You mean that you want to specify this alignment attribute every time
> > > > you create an IOMMU mapping? Then you can set segment_boundary_mask
> > > > every time you create an IOMMU mapping. It's odd but it should work.
> > > 
> > > Kinda. I want to forget about IOMMUs, devices and CPUs. I just want to
> > > create a mapping that has the alignment I specify, regardless of the
> > > mapper. The mapping is created on a VCM and the VCM is associated with
> > > a mapper: a CPU, an IOMMU'd device or a direct mapped device.
> > 
> > Sounds like you can do the above with the combination of the current
> > APIs, create a virtual address and then an I/O address.
> > 
> 
> Yes, and that's what the implementation does - and all the other
> implementations that need to do this same thing. Why not solve the
> problem once?

Why we we need a new abstraction layer to solve the problem that the
current API can handle?

The above two operations don't sound too complicated. The combination
of the current API sounds much simpler than your new abstraction.

Please show how the combination of the current APIs doesn't
work. Otherwise, we can't see what's the benefit of your new
abstraction.
