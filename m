Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab2J3Jd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:33:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42905 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab2J3JdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:33:25 -0400
X-AuditID: cbfee61b-b7f616d00000319b-36-508f9ee32ca0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Subject: Re: [PATCH 4/4] DMA: PL330: add device tree property for DMA_MEMCPY
 capability
Date: Tue, 30 Oct 2012 10:21:42 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, vinod.koul@intel.com,
        kgene.kim@samsung.com, rob.herring@calxeda.com, dinguyen@altera.com,
        pawel.moll@arm.com, t.figa@samsung.com, kyungmin.park@samsung.com
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <1351504796-24788-5-git-send-email-b.zolnierkie@samsung.com>
 <CABb+yY1Ztu2n38ObXJq+shOoXw6yk0YK39QUHhDN_pJKziAFQg@mail.gmail.com>
In-reply-to: <CABb+yY1Ztu2n38ObXJq+shOoXw6yk0YK39QUHhDN_pJKziAFQg@mail.gmail.com>
MIME-version: 1.0
Message-id: <201210301021.42803.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAd3H8/oDDNZ+Ere4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MqYdrmPreAkZ8XDw0/ZGxhvsHcxcnJICJhILL7eygJh
	i0lcuLeerYuRi0NIYBGjRNPSWUwQTguTxIJ5C8Gq2ASsJCa2r2IEsUUENCWWvZ7HBGILC0RK
	nJjWygZiswioSrz/tQOsXlTAQaJz6gSwqcwCvUwSB7c9YIWYeo5R4sjec2B3cAoESzxu6WEF
	sXkFBCV+TL7HAmFbSuy8/5EZxGYW0JJofrOJEcKWl9i85i3zBEaBWUhaZiEpm4WkbAEj8ypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4IB8Jr2DcVWDxSFGAQ5GJR7ejWv6AoRYE8uKK3MP
	MUpwMCuJ8M6e1B8gxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVASCA9sSQ1OzW1ILUIJsvE
	wSnVwBjfrv/5xvr04tqjt4yTTTTWuV6dsDIu0uVi2OZkKfYNqnVW50QWn1D4wSh5l9mlMlIr
	3c7ff2FlWUnM6Vrvfw8uXZOvXH2l7Zig84OXmtZ8KoeEHPgmqMWdKKuZ8/SxfWj633d3LiW3
	tPAvm2O1fY45n9DZkgv3XL4s5DtoOKPcNb/Vr0lwjhJLcUaioRZzUXEiABc8SIBEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 29 October 2012 22:45:48 Jassi Brar wrote:
> On Mon, Oct 29, 2012 at 10:59 AM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > * Add device tree (DT) property ("pl330,dma-memcpy") for DMA_MEMCPY
> >   capability and instead of setting this capability unconditionally
> >   in pl330_probe() do it only when property is present.
> >
> Perhaps we should pass the array of peripheral interfaces via DT, the
> lack of which could imply MEMCPY capability ? (while it works, I doubt
> if pl330 is supposed to have SLAVE and MEMCPY capabilities in any
> instance)

In case of PL330 on EXYNOS4 we have two interfaces with SLAVE capability
and one interface with MEMCPY capability.  Could you please explain more
the idea of passing the array of peripherals through DT so we can detect
which interface has MEMCPY capability?

> That would also be a step towards discarding "struct dma_pl330_platdata".

I don't know if getting rid of "struct dma_pl330_platdata" is possible
but we still need to come up with some way to pass the needed information
through DT.  Do you have an idea how it could be done?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
