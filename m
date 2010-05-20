Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0ETMSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:18:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab0ETMSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:18:16 -0400
Date: Thu, 20 May 2010 08:18:11 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davem@davemloft.net, dwmw2@infradead.org,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>, stable@kernel.org
Subject: Re: [PATCH -mm 5/6] parisc: set ARCH_KMALLOC_MINALIGN
Message-ID: <20100520121811.GB21791@bombadil.infradead.org>
References: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1274325703-11092-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274325703-11092-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 12:21:42PM +0900, FUJITA Tomonori wrote:
> Architectures that handle DMA-non-coherent memory need to set
> ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
> the buffer doesn't share a cache with the others.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 

Applied, thanks!

regards, Kyle
