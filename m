Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0GaCbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 22:31:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:35396 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab0GaCbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 22:31:41 -0400
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stepanm@codeaurora.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
References: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
	 <201007281950.20847.arnd@arndb.de>
	 <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org>
	 <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 12:30:49 +1000
Message-ID: <1280543449.1902.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 12:35 +0900, FUJITA Tomonori wrote:
> Don't confuse the IOMMU interface with the DMA API that Arnd
> mentioned.
> 
> They are not related at all.
> 
> The DMA API is defined in Documentation/DMA-API.txt.
> 
> Arnd told you that include/asm-generic/dma-mapping-common.h is the
> library to support the DMA API with multiple IOMMUs. Lots of
> architectures (x86, powerpc, sh, alpha, ia64, microblaze, sparc)
> use it. 

Also, some of the iommu layer actually originates from powerpc.

Cheers,
Ben.


