Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2H2Rtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:49:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57595 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2H2Rt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120810145750.5490.5639.stgit@patser.local>
References: <20120810145728.5490.44707.stgit@patser.local>
	<20120810145750.5490.5639.stgit@patser.local>
Date: Wed, 29 Aug 2012 19:49:27 +0200
Message-ID: <CAOau3s8hCrvcA7=p5v=SgnGziH5=mAA1wR6r9nvpcDt_1KbhWA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 2/4] dma-fence: dma-buf synchronization
 (v8 )
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: sumit.semwal@linaro.org, rob.clark@linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 10, 2012 at 4:57 PM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:

[Snip]

> diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
> new file mode 100644
> index 0000000..e0ceddd
> --- /dev/null
> +++ b/include/linux/dma-fence.h
> @@ -0,0 +1,124 @@
> +/*
> + * Fence mechanism for dma-buf to allow for asynchronous dma access
> + *
> + * Copyright (C) 2012 Texas Instruments
> + * Author: Rob Clark <rob.clark@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> it
> + * under the terms of the GNU General Public License version 2 as
> published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __DMA_FENCE_H__
> +#define __DMA_FENCE_H__
> +
> +#include <linux/err.h>
> +#include <linux/list.h>
> +#include <linux/wait.h>
> +#include <linux/list.h>

Duplicated include.

Regards,
Francesco
