Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1D1Oaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:30:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52745 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab1D1OaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:30:25 -0400
Date: Thu, 28 Apr 2011 15:30:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joerg Roedel <joro@8bytes.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428143009.GO17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <20110428122508.GC13402@8bytes.org> <20110428124242.GJ17290@n2100.arm.linux.org.uk> <201104281502.16296.arnd@arndb.de> <20110428131928.GL17290@n2100.arm.linux.org.uk> <20110428135621.GE13402@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428135621.GE13402@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 03:56:21PM +0200, Joerg Roedel wrote:
> There is no waste of code, just the opposite. Most of the dma_ops
> implementations that use an IOMMU today have a lot of similiarities in
> their code. All this code (on x86, alpha, sparc, ia64, ...) can
> be unified to a generic solution that fits all (by abstracting the
> differences between iommus into the iommu-api). So the current situation
> is a much bigger code waste than having this unified. The ARM platforms
> supporting iommu hardware will benefit from this as well. It simply
> doesn't make sense to have one dma_ops implementation for each iommu
> hardware around.

I'll defer until there's patches available then - I don't think there's
much value continuing to discuss this until that time.
