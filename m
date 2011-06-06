Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1FFJKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:10:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50283 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1FFJKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:10:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
Date: Mon, 6 Jun 2011 11:10:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        laurent.pinchart@ideasonboard.com, Hiroshi.DOYU@nokia.com,
        davidb@codeaurora.org, Joerg.Roedel@amd.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, anil.s.keshavamurthy@intel.com
References: <1307053663-24572-1-git-send-email-ohad@wizery.com> <201106031753.16095.arnd@arndb.de> <BANLkTim2pDu25ZudZ7ZzOwka0V1sYEhDKw@mail.gmail.com>
In-Reply-To: <BANLkTim2pDu25ZudZ7ZzOwka0V1sYEhDKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061110.30601.arnd@arndb.de>
X-Provags-ID: V02:K0:aJ6EVbmPrI8OjVCaoknZktHXefNc70PoG56ZsI+XEAX
 m8SZW3IbXk4/bYDQlfgR4Ae/WEoahCGj6T0Fn1Le7Y1OOQN92d
 BEEwAFXQ7Y6ZXA8OWNVJbKULYu6lnlwTXibnP8Gs2HEGf90rOk
 kZhghwmHyOFvAj00ikFnjyeXGCYxNCeC3lQSmY2T3V4tUsqJVo
 oQ+WznHm8m83Xlci1DQ6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 June 2011, Ohad Ben-Cohen wrote:
> > As far as I can tell, once we have that in
> > place, we you can migrate omap3isp from iovmm to dma-mapping and
> > remove iovmm.
> 
> Sounds like a plan.
> 
> I'd still prefer us to take small steps here, and not gate the omap
> iommu cleanups with Marek's generic dma_map_ops work though. Let's go
> forward and migrate omap's iommu to the generic iommu API, so new code
> will be able to use it (e.g. the long coming virtio-based IPC/AMP
> framework).

Yes, of course. That's what I meant. Moving over omap to the IOMMU API
is required anyway, so there is no point delaying that.

> We'll migrate iovmm/omap3isp just enough so they don't break, but once
> the generic dma_map_ops work materializes, we'd be able to complete
> the migration, remove iovmm, and decouple omap3isp from omap-specific
> iommu APIs for good.

Ok, great!

	Arnd
