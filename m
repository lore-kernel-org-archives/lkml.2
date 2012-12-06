Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965237Ab2LFPt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:49:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16229 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965176Ab2LFPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:49:56 -0500
X-AuditID: cbfee61b-b7f616d00000319b-0d-50c0bea278f4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 02/12] dmaengine: prepare for generic 'unmap' data
Date: Thu, 06 Dec 2012 16:47:51 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com, linux@arm.linux.org.uk,
        dave.jiang@intel.com
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
 <20121206092519.17085.38983.stgit@dev279.prn1.facebook.com>
In-reply-to: <20121206092519.17085.38983.stgit@dev279.prn1.facebook.com>
MIME-version: 1.0
Message-id: <201212061647.51503.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAd1F+w4EGKzYJ29xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyPn0oLXjPWrHn/2amBsZ3LF2MnBwSAiYSzQt+MELYYhIX7q1n
	A7GFBBYxSkz/qNXFyAVkL2WS2HH3ITNIgk3ASmJi+yqwBhEBOYnVt6eAxYUF3CSaL7eCDWUR
	UJX4sG8+WFxUwEGic+oEsKHMAmkSL57PZ4QY2sooseF3K1gRp4CHxKnJ/UwgNq+AoMSPyfeA
	BnEA2ZYSn86pQvRqSTS/2cQIYctLbF7zlnkCo8AsJB2zkJTNQlK2gJF5FaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZw+D2T3sG4qsHiEKMAB6MSD69F9f4AIdbEsuLK3EOMEhzMSiK8MR0H
	AoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzNnukBAgJpCeWpGanphakFsFkmTg4pRoYjedNPhi2
	hfGnoeYCMQnOQOGThqKxgUHbzj2rOPh+8z+ertaohH0Bj7Z/+cA197tlru3FfdwzX79w136Q
	ITxzb/elT6Iangl2AfMlytwnWd+NuLft4+2kC90bZXz0P4admnA739KfZ2rT07m9qj7K0htO
	8c+9tGLSPKkDn04/Npy8dY6waVnANyWW4oxEQy3mouJEAP7YuA07AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2012 10:25:20 Dan Williams wrote:
> Add a hook for a common dma unmap implementation to enable removal of
> the per driver custom unmap code.  (A reworked version of Bartlomiej
> Zolnierkiewicz's patches to remove the custom callbacks and the size
> increase of dma_async_tx_descriptor for drivers that don't care about raid).
> 
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Dan Williams <djbw@fb.com>

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Thanks for reworking my patches!  The patchset looks generally
good but there are few issues that should be fixed (please see
other mails).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
