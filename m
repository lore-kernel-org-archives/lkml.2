Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2KHLY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:24:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28434 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab2KHLX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:23:28 -0500
X-AuditID: cbfee61b-b7f616d00000319b-c9-509b962e0f72
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] DMA: remove unused support for MEMSET operations
Date: Thu, 08 Nov 2012 12:22:05 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <201211081058.17897.b.zolnierkie@samsung.com>
 <20121108111231.1fc95397@pyramind.ukuu.org.uk>
In-reply-to: <20121108111231.1fc95397@pyramind.ukuu.org.uk>
MIME-version: 1.0
Message-id: <201211081222.05612.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jQV29abMDDDqXG1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mnt0X2AoesVXc6VjO1sC4jbWLkYNDQsBE4vxd+y5GTiBTTOLC
	vfVsXYxcHEIC0xklZq38D+UsZZKYfHcxO0gVm4CVxMT2VYwgtoiAusTUFdPZQGxhAVeJu2+/
	gtksAqoSq042gdWLCjhIdE6dADaIWWADo8SdeXNZQRJCAlkS/1fOAWvgFLCWOHfyPNhQXgFB
	iR+T77FA2JYSi6ffBhvELKAl0fxmEyOELS+xec1b5gmMArOQtMxCUjYLSdkCRuZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMEh+Ex6B+OqBotDjAIcjEo8vBqSswOEWBPLiitzDzFKcDAr
	ifByTAAK8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnNTk0tSC2CyTJxcEo1MDYv
	1t3Yfzrq0LwJrHO/2zOWvpTv5uea28gWNv9Mx40Y0+IT82ek7pv69YHlpaebqmxOve1zXX7h
	yvT+PYV8E72aNVhLDHY9SNR7+aN+0dEzuVM8PGYKTt973yDLzGu5uPXSyU9Zv548xhCx94br
	4YT5emwrv/iKX3g31+ItC38P/0OOuW0l8z8psRRnJBpqMRcVJwIAjr8L2j0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012 12:12:31 Alan Cox wrote:
> On Thu, 08 Nov 2012 10:58:17 +0100
> Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Subject: [PATCH] DMA: remove unused support for MEMSET operations
> > 
> > There have never been any real users of MEMSET operations
> 
> In tree users.

Please show me them.  There were no users except self-test one
(which this patch also removes), the whole memset code has been
dead since its introduction in January 2007.

> And is it broken, if not why do you want to break it ?

Well, it is partially broken as async_memset.c doesn't even built
currently in next (I've posted fix for that before noticing that
the whole code can be removed).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
