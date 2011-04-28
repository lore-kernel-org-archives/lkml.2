Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587Ab1D1Oio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:38:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:39357 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1D1Oin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:38:43 -0400
Date: Thu, 28 Apr 2011 23:38:07 +0900
To: arnd@arndb.de
Cc: linux@arm.linux.org.uk, fujita.tomonori@lab.ntt.co.jp,
        m.szyprowski@samsung.com, benh@kernel.crashing.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201104281629.52863.arnd@arndb.de>
References: <201104281428.56780.arnd@arndb.de>
	<20110428131531.GK17290@n2100.arm.linux.org.uk>
	<201104281629.52863.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110428233538V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 28 Apr 2011 23:38:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm busy at a conference so I've not read the whole thread yet..

On Thu, 28 Apr 2011 16:29:52 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> I was mistaken there: all drivers that use dma_alloc_noncoherent
> either use dma_cache_sync() or they do something that is more broken,
> but they don't do dma_sync_*.

As the DMA-API.txt says, dma_alloc_noncoherent should be used with
dma_cache_sync(). You shouldn't use dma_sync* API with a memory
returned by dma_alloc_noncoherent().
