Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0HBJEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:04:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50693 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0HBJEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:04:01 -0400
Date: Mon, 2 Aug 2010 10:03:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: benh@kernel.crashing.org, dwalker@codeaurora.org, arnd@arndb.de,
        Joerg.Roedel@amd.com, linux-kernel@vger.kernel.org,
        stepanm@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100802090326.GA30670@n2100.arm.linux.org.uk>
References: <1280546124.1902.30.camel@pasglop> <20100802074812.GM24084@amd.com> <1280736182.1902.55.camel@pasglop> <20100802172941C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802172941C.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 05:30:26PM +0900, FUJITA Tomonori wrote:
> ARM's iommu code (arch/plat-omap/include/plat/iommu.h) is a library to
> simplify the IOMMU implementations. It could be useful for all the
> iommu implementations.

ITYM OMAP's iommu code.
