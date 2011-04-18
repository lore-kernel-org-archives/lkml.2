Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1DRNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:25:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65430 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1DRNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:25:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
Date: Mon, 18 Apr 2011 15:25:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: tony@atomide.com, linux@arm.linux.org.uk, fernando.lugo@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, grgupta@ti.com, h-kanigeri2@ti.com
References: <20110414223036.GA7335@n2100.arm.linux.org.uk> <20110418110502.GI12272@atomide.com> <20110418.144246.77604458849535045.Hiroshi.DOYU@nokia.com>
In-Reply-To: <20110418.144246.77604458849535045.Hiroshi.DOYU@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104181525.43481.arnd@arndb.de>
X-Provags-ID: V02:K0:KnynaJq9SxCayKB28dfiQxc1RyKG9F0rt2NJEJK2TmU
 SCiudX/wHYpVE4peqmtkszZ6+5vH6/igP8qPg+gMpndXhrAbH1
 C7In4ZIof8Q3xljzjCiZNhL2uZBNvBh3j0h3RGkHE83TqXL2Py
 EW2GNv8UJLNyI6EMbDyiqyX1xJse1byiwcOTrjtkXOZWQQ3u6r
 cYmifRU9GztQii2MAF0Aw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Hiroshi DOYU wrote:
> From: ext Tony Lindgren <tony@atomide.com>

> > have a generic replacement for this code we should start using it.
> 
> I'm afraid that there's no general IOMMU APIs yet, or already? If
> there is, migrating to those general IOMMU API is the way, but still
> SoC dependent parts remain, anyway. I guess that more or less general
> IOMMU API is composed of common set of client APIs(like IOVMM) and the
> registration of H/W dependent functions(like omap iommu), I guess.

As I explained, we have a surplus of generic iommu APIs
already, see include/linux/dma-mapping.h and include/linux/iommu.h
 
The dma-mapping interface handles IOMMUs on all other architectures
that have them.

	Arnd
