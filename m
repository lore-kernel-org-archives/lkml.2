Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2DZOIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:08:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60679 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2DZOIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:08:12 -0400
Date: Thu, 26 Apr 2012 16:08:09 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: videobuf2-dma-contig: quiet sparse noise about
 plain integer as NULL pointer
In-reply-to: <201204241612.49058.hartleys@visionengravers.com>
To: "'H Hartley Sweeten'" <hartleys@visionengravers.com>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, pawel@osciak.com, kyungmin.park@samsung.com,
        mchehab@infradead.org
Message-id: <004b01cd23b6$025e0ab0$071a2010$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac0ib8oKMxlLEYFMS2GXYgD4Eh8gngBRgjhg
References: <201204241612.49058.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, April 25, 2012 1:13 AM H Hartley Sweeten wrote:
 
> The function vb2_dma_contig_vaddr returns a void * not an integer.
> 
> Quiets the sparse noise:
> 
> warning: Using plain integer as NULL pointer
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
> index f17ad98..7de6843 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -85,7 +85,7 @@ static void *vb2_dma_contig_vaddr(void *buf_priv)
>  {
>  	struct vb2_dc_buf *buf = buf_priv;
>  	if (!buf)
> -		return 0;
> +		return NULL;
> 
>  	return buf->vaddr;
>  }

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

