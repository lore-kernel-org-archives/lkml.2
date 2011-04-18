Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1DROOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:14:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64913 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1DROOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:14:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
Date: Mon, 18 Apr 2011 16:13:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
        Ramesh Gupta <grgupta@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com> <201104181358.53521.arnd@arndb.de> <BANLkTimc20N0nh9O0FaSXizW+bYOMx9Ddw@mail.gmail.com>
In-Reply-To: <BANLkTimc20N0nh9O0FaSXizW+bYOMx9Ddw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104181613.43572.arnd@arndb.de>
X-Provags-ID: V02:K0:J6AVZOk0KLGNElh9PfL9eSe6TFltN7w18pqYgGFFLvS
 EgtNSzRDAoPcyUUx/fwWMhAktbpSerYNB6Quwfr8Raeu2ZRb+x
 6CV1MQrA3qW+nIJtdInNhT8ZPV8p8+UCzd16ka9q6405+n3KBU
 HoFZjJAfz/75a+yBwODvytoplV6BRStm3Jrgdvf73iEFGEeCEg
 hpSBh8IdZbGZadtkE4NbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Kyungmin Park wrote:
> On Mon, Apr 18, 2011 at 8:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > One missing piece is still a way for a platform to provide both
> > the iommu and the dma-mapping API in a unified driver. Right now,
> > you have to export both interface for a generic solution.
> 
> Actually MSM and we (Michal, Marek) tried to merge the generic IOMMU
> implementation into mm, but MM did't accept it.

I'm confused. What do you mean with MM?

> So now it's implemented at each SoCs. I think it's good chance to make
> a generic IOMMU feature for ARM consolidation.
>
> Before this idea, can you review our implementation at above URL?

I've commented on the main implementation for the IOMMU now.

	Arnd
