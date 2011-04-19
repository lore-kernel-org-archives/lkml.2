Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1DSMB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:01:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab1DSMB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:01:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
Date: Tue, 19 Apr 2011 14:01:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Hari Kanigeri <h-kanigeri2@ti.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Ramesh Gupta <grgupta@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com> <201104181613.43572.arnd@arndb.de> <BANLkTi=dpqMFjW_B5-YsmoCJf62b8djj5g@mail.gmail.com>
In-Reply-To: <BANLkTi=dpqMFjW_B5-YsmoCJf62b8djj5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191401.34818.arnd@arndb.de>
X-Provags-ID: V02:K0:3nd9wXuO9ecoqw75u3NkbnW6sMRUxl4/dp9DkFMPHlr
 5xkUlaQNo72A6Ebxj1Q+0BrV2+abFeW7VYIz0Pbvp7UculQozS
 LWbOSbglh6Ah4YF3V8xwYjUE/8R00sQdFIvcbfLaZbu8LzLZvp
 +zaOQbkJzQKttNeaPp5CIqRHeo2VuXeOtLa4E6Lp7J38HyILAS
 6qD7kfyEhNP967+81dPFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 April 2011, Kyungmin Park wrote:
> On Mon, Apr 18, 2011 at 11:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 18 April 2011, Kyungmin Park wrote:
> >> On Mon, Apr 18, 2011 at 8:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> >
> >> > One missing piece is still a way for a platform to provide both
> >> > the iommu and the dma-mapping API in a unified driver. Right now,
> >> > you have to export both interface for a generic solution.
> >>
> >> Actually MSM and we (Michal, Marek) tried to merge the generic IOMMU
> >> implementation into mm, but MM did't accept it.
> >
> > I'm confused. What do you mean with MM?
> linux/mm, Memory Management.

I'm still confused. What were you suggesting to merge in there?
Do you have a link to a mailing list discussion?

	Arnd
