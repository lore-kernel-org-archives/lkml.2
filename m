Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2ERELI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:11:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63420 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2ERELH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <4F8E04D2.7070708@xenotime.net>
References: <4F8E04D2.7070708@xenotime.net>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 18 May 2012 09:40:45 +0530
Message-ID: <CAO_48GFQ=zO+EkX3ZW7=-035BZuoFR-xTUBp2BYoQUoraKhsnw@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix dma-buf.c kernel-doc warnings
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On 18 April 2012 05:33, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix kernel-doc warnings in dma-buf.c:
>
> Warning(drivers/base/dma-buf.c:305): No description found for parameter 'dmabuf'
> Warning(drivers/base/dma-buf.c:305): Excess function parameter 'dma_buf' description in 'dma_buf_begin_cpu_access'
> Warning(drivers/base/dma-buf.c:332): No description found for parameter 'dmabuf'
> Warning(drivers/base/dma-buf.c:332): Excess function parameter 'dma_buf' description in 'dma_buf_end_cpu_access'
> Warning(drivers/base/dma-buf.c:350): No description found for parameter 'dmabuf'
> Warning(drivers/base/dma-buf.c:350): Excess function parameter 'dma_buf' description in 'dma_buf_kmap_atomic'
> Warning(drivers/base/dma-buf.c:367): No description found for parameter 'dmabuf'
> Warning(drivers/base/dma-buf.c:367): Excess function parameter 'dma_buf' description in 'dma_buf_kunmap_atomic'
> Warning(drivers/base/dma-buf.c:385): No description found for parameter 'dmabuf'
> Warning(drivers/base/dma-buf.c:385): Excess function parameter 'dma_buf' description in 'dma_buf_kmap'
> Warning(drivers/base/dma-buf.c:402): No description found for parameter 'dmabuf'
> Warning(drivers/base/dma-buf.c:402): Excess function parameter 'dma_buf' description in 'dma_buf_kunmap'
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks, applied to my for-next.
Sorry, I was away due to some medical reasons for some time, hence the delay.
> ---
<snip>

Best regards,
~Sumit.
