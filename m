Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2K3LIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:08:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15080 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab2K3LIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:08:39 -0500
X-AuditID: cbfee61b-b7f616d00000319b-19-50b893b6445b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <1354045994-8977-1-git-send-email-dianders@chromium.org>
 <CAOesGMjyXZwKjycyVcEV0ty0LCM_i61QxykYPhAvXxx2rhgP+A@mail.gmail.com>
 <50B53E37.40303@samsung.com>
 <CAOesGMivs=NA6hcTYWO-MWUeUjVGZ0h258z1MpeexXGtVf9h-g@mail.gmail.com>
 <18d701cdcd28$74198d70$5c4ca850$%kim@samsung.com>
 <20121128060553.GA18166@quad.lixom.net>
 <CAD=FV=WvDWrT_vCT8W48mKFU4O2n-_yDz+SpFpqx3B25tvmRKA@mail.gmail.com>
 <CAOesGMj9nw4230jBMyWR8L6c21iKvH-YHAQf8=MdTE-ANrZpgA@mail.gmail.com>
In-reply-to: <CAOesGMj9nw4230jBMyWR8L6c21iKvH-YHAQf8=MdTE-ANrZpgA@mail.gmail.com>
Subject: RE: [PATCH] ARM: EXYNOS: Avoid early use of of_machine_is_compatible()
Date: Fri, 30 Nov 2012 20:08:38 +0900
Message-id: <1d7701cdceeb$0c441fc0$24cc5f40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Nj/xEOql0FFqjTraTbNkstjIpUQBWr4/Q
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zQ91tk3cEGNx6IWJxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJXx7Ptc5oI73BU7f6s1MHZwdjFyckgImEjMu/STEcIW
	k7hwbz1bFyMXh5DAMkaJO20/2GCKZvdvYwaxhQSmM0qsmZ8BUfSXUeLa1iNMIAk2AQ2Jw++f
	sYPYIgJ+Ehs6N7CAFDELbGeUWNy5lh2i4y6zxPS/N8E6OAWCJR5/OQdmCwv4S0w/txasm0VA
	VWLR9o9gNq+ArcTLQ21QtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8BTqPA+hUdYlHf3UhjjCS
	6L67CqpcRGLfi3eMEOMFJL5NPsQCUS4rsekAM8hpEgKr2CU+vDvKAvGxpMTBFTdYJjBKzEKy
	eRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFRJr2DcVWDxSFGAQ5G
	JR5ehjXbA4RYE8uKK3MPMUpwMCuJ8O4T3BEgxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnA
	BJBXEm9obGxiZmJqYm5pam6KQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUAyPnFAN9dbEY
	to1Cz8s932XOP3+uufotQ4BRBG9OnNkTriOfPpTwB1lsN7ZQiZ/uJ3Am5vPsXfZNvTva7swu
	mbR/+d/Pn7TOrWF9FVrdnMAyv3u9rEXrp4atfdO7Nkts/vKH6afDBt0u96YiFeHsX9wGxQbF
	Ecea1t+2C/+t9i4yuXeH+fbFX5RYijMSDbWYi4oTAfUuwcffAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd1tk3cEGFw9KWBxedccNosZ5/cx
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8ez7XOaCO9wV
	O3+rNTB2cHYxcnJICJhIzO7fxgxhi0lcuLeeDcQWEpjOKLFmfkYXIxeQ/ZdR4trWI0wgCTYB
	DYnD75+xg9giAn4SGzo3sIAUMQtsZ5RY3LmWHaLjLrPE9L83wTo4BYIlHn85B2YLC/hLTD+3
	FqybRUBVYtH2j2A2r4CtxMtDbVC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17wFOpUD6FR1iUd/
	dSGOMJLovrsKqlxEYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5x
	aV66XnJ+7iZGcAw/k97BuKrB4hCjAAejEg8vw5rtAUKsiWXFlbmHGCU4mJVEePcJ7ggQ4k1J
	rKxKLcqPLyrNSS0+xOgD9OhEZinR5HxgeskriTc0NjEzsjQyszAyMTfHIawkztvskRIgJJCe
	WJKanZpakFoEM46Jg1OqgdHYma2xbY3mkwL17arz5V69C8p4s01oraF/vtCWC/eleO13XTNJ
	Ymd+H2U8/5xQ5bVjKg7TlgmGf7zZ2s7V43rC6p7cn5iPG6yOpr5YLzbpoEx/sUziHM5OHfu7
	YcIfY6bt2a3LKK7++8kujYUCC9d8vxSikLFynf2X3TY8rEccevXvFLGsq1JiKc5INNRiLipO
	BADmg4MZDgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Wed, Nov 28, 2012 at 8:16 AM, Doug Anderson <dianders@chromium.org>
> wrote:
> > Olof / Kukjin,
> >

[...]

> >>
> >> I really don't like splitting an if/else with an ifdef like this, it's
> fragile
> >> code and can be hard to follow.
> >
> > Agree.

Definitely, same here ;-)

> >> There's also a second build error with exynos_defconfig in the
> >> exynos5-dt.c board file due to a missing include. Teaches me to just
> apply
> >> patches without trying to build. :(
> >
> > In the tree I was testing against (the arm-soc/for-next branch at
> > 659b19ca3a77e2ac32fe84d95242653c75dd07c7) I see the include file in
> > the exynos5-dt.c file already.  In my tree it was added by "2eae613b:
> > ARM: EXYNOS: Add MFC device tree support".
> >
> > Your patch applies cleanly on mine but I end up with:
> >
> >   #include <linux/of_platform.h>
> >   #include <linux/of_fdt.h>
> >   #include <linux/serial_core.h>
> >   #include <linux/io.h>
> >   #include <linux/memblock.h>
> >   #include <linux/of_fdt.h>
> 
> Sigh, this is because people add includes out of alphabetical order.

Yeah.

> We'll just have to fix it up later, 

Sure, I will after release 3.8-rc1.

[...]
> 
> I've pushed out the branch with the patch applied (with the above
changed).
> 
Thanks for your fix.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

