Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424004Ab2LFPuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:50:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16233 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423981Ab2LFPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:49:59 -0500
X-AuditID: cbfee61b-b7f616d00000319b-24-50c0bea67e4a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 07/12] async_xor_val: convert to dmaengine_unmap_data
Date: Thu, 06 Dec 2012 16:48:04 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, vinod.koul@intel.com,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
 <20121206092548.17085.19899.stgit@dev279.prn1.facebook.com>
In-reply-to: <20121206092548.17085.19899.stgit@dev279.prn1.facebook.com>
MIME-version: 1.0
Message-id: <201212061648.04486.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t9jAd1l+w4EGLTuEbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ+6ZvYSw4y1yx48561gbGduYuRk4OCQETiecNjSwQtpjEhXvr
	2boYuTiEBBYxSpxbexXKWcoksf7LQ7AONgEriYntqxhBbBEBOYnVt6eAxYUFPCW+T7kAZHNw
	sAioShycEgsSFhVwkOicOgFsDrPAVkaJ7092skIMbWWU6J5+gQmkilPAQ2LehnWsIDavgKDE
	j8n3WCBsS4n3jd/YQWxmAS2J5jebGCFseYnNa94yT2AUmIWkZRaSsllIyhYwMq9iFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECA7CZ9I7GFc1WBxiFOBgVOLhtajeHyDEmlhWXJl7iFGCg1lJ
	hDem40CAEG9KYmVValF+fFFpTmrxIUZpDhYlcd5mj5QAIYH0xJLU7NTUgtQimCwTB6dUA+OM
	kiz9U486Zdptlx9ovL1yr/Mk9ZLT+j0V90WDX5jM7WP+9vDCkr1f1nWWJ7U2tyicydogs2eH
	3IyLZhd+BSc+TRBiiJNTyW9zFOVfzbRT6trD0+smmvVx5V3rs0zqdom+0ljbmFQY6LZm4tNd
	RdN/m18998p3NU99YVKZ1Z15WpdyL9r3aCqxFGckGmoxFxUnAgCar/vBPgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2012 10:25:48 Dan Williams wrote:
> Use the generic unmap object to unmap dma buffers.
> 
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Dan Williams <djbw@fb.com>

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
