Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2LLPJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:09:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37646 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2LLPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:09:50 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-7b-50c89e36fe3d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Subject: Re: [PATCH 1/4] DMA: PL330: fix locking in pl330_free_chan_resources()
Date: Wed, 12 Dec 2012 16:08:53 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        rob.herring@calxeda.com, dinguyen@altera.com, pawel.moll@arm.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Dan Williams <djbw@fb.com>
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <201211301159.31098.b.zolnierkie@samsung.com>
 <1354298873.7077.76.camel@vkoul-udesk3>
In-reply-to: <1354298873.7077.76.camel@vkoul-udesk3>
MIME-version: 1.0
Message-id: <201212121608.53648.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAV2zeScCDJ7dlLS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4dsuqYBVzxbmlC1kbGC8zdTFyckgImEhs7PjMDmGL
	SVy4t56ti5GLQ0hgEaPE5q2TWCGcFiaJ9483M4JUsQlYSUxsXwVmiwhoSzztuwhmCwv4S9ye
	+48FxGYRUJX49QqkmZNDVMBBonPqBLCpzAJ7mCRmXDmIsKJ/3gKg3RwcnEB3rHiZCtLAKyAo
	8WPyPRYI21Li2qdfYAuYBbQkmt9sgrLlJTavecs8gVFgFpKWWUjKZiEpW8DIvIpRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOBifSe1gXNlgcYhRgINRiYe34d3xACHWxLLiytxDjBIczEoi
	vIvqTgQI8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnNTk0tSC2CyTJxcEo1MPZH
	NHJskd4buuMWz/3Z+1X+vD/3Ru1Kjpb924aDT+skbZV2f5h7pWueYX+Q+crYyJjt9qsL+6Z7
	n/fsWpcgs3nbsa/JhTeETh0vr7+oVb2/MNM9L25rOG/Ju7ybRkXWyVVegko51Yfv8L14J2cV
	tfqliHfuAqeXdRlHJh3XDFmZciPh3kkzQyWW4oxEQy3mouJEAL4mbCBCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2012 19:07:53 Vinod Koul wrote:
> On Fri, 2012-11-30 at 11:59 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
> > 
> > Vinod/Dan could you please pick this patch for 3.8?  Thanks!
> I will check and queue it up today

ping?  [ I can't find the patch in slave-dma.git tree. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
