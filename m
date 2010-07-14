Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0GNWHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:07:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54154 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab0GNWHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:07:02 -0400
Date: Wed, 14 Jul 2010 23:05:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, ebiederm@xmission.com,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
	memory management
Message-ID: <20100714220536.GE18138@n2100.arm.linux.org.uk>
References: <4C3C0032.5020702@codeaurora.org> <20100713150311B.fujita.tomonori@lab.ntt.co.jp> <20100713121420.GB4263@codeaurora.org> <20100714104353B.fujita.tomonori@lab.ntt.co.jp> <20100714201149.GA14008@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714201149.GA14008@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 01:11:49PM -0700, Zach Pfeffer wrote:
> If the DMA-API contained functions to allocate virtual space separate
> from physical space and reworked how chained buffers functioned it
> would probably work - but then things start to look like the VCM API
> which does graph based map management.

Every additional virtual mapping of a physical buffer results in
additional cache aliases on aliasing caches, and more workload for
developers to sort out the cache aliasing issues.

What does VCM to do mitigate that?
