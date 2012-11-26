Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2KZWwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:52:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:37520 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625Ab2KZWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:52:09 -0500
Date: Mon, 26 Nov 2012 14:52:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Fw: [PATCH] dma-mapping: fix dma_common_get_sgtable()
 conditional compilation
Message-ID: <20121126225206.GC28995@kroah.com>
References: <20121126181837.0596a25a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126181837.0596a25a@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 06:18:37PM -0200, Mauro Carvalho Chehab wrote:
> Hi Greg,
> 
> Are you maintaining drivers/base/dma-mapping.c? The enclosed path is needed to
> enable DMABUF handling on V4L2 on some architectures, like x86_64, as we need
> dma_common_get_sgtable() on drivers/media/v4l2-core/videobuf2-dma-contig.c.
> 
> Would you mind acking it, in order to let this patch flow via my tree? This way,
> I can revert a workaround I had to apply there, in order to avoid linux-next
> compilation breakage.
> 
> Thanks!
> Mauro
> 
> -
> 
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> Date: Mon, 26 Nov 2012 14:41:48 +0100
> 
> dma_common_get_sgtable() function doesn't depend on
> ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY, so it must not be compiled
> conditionally.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

