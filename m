Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2DZOIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:08:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57019 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2DZOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:08:50 -0400
Date: Thu, 26 Apr 2012 16:08:47 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: videobuf2-dma-contig: include header for exported
 symbols
In-reply-to: <201204241608.13305.hartleys@visionengravers.com>
To: "'H Hartley Sweeten'" <hartleys@visionengravers.com>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, pawel@osciak.com, kyungmin.park@samsung.com,
        mchehab@infradead.org
Message-id: <004c01cd23b6$19342440$4b9c6cc0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac0ibyfqFx+OA7KXQ6C/OfQkk2nF5QBRt2ew
References: <201204241608.13305.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, April 25, 2012 1:08 AM H Hartley Sweeten wrote:

> Include the header to pickup the definitions of the exported symbols.
> 
> Quiets the following sparse warnings:
> 
> warning: symbol 'vb2_dma_contig_memops' was not declared. Should it be static?
> warning: symbol 'vb2_dma_contig_init_ctx' was not declared. Should it be static?
> warning: symbol 'vb2_dma_contig_cleanup_ctx' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-
> contig.c
> index f17ad98..a1bee6c 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -15,6 +15,7 @@
>  #include <linux/dma-mapping.h>
> 
>  #include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
>  #include <media/videobuf2-memops.h>
> 
>  struct vb2_dc_conf {

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

