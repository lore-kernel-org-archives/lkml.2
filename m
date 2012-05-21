Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2EUQDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:03:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50051 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2EUQDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <4FBA4B84.9030302@chelsio.com>
References: <20120521120512.15f1e9dfc961b05dfee72f79@canb.auug.org.au> <4FBA4B84.9030302@chelsio.com>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 21 May 2012 09:03:08 -0700
X-Google-Sender-Auth: N9kmuU4RY1eZ_YxS8E_vFeQoW9k
Message-ID: <CAG4TOxNUzGgS_pkGcxBx1FZdPSVB=7E-bC40+8VPMhgZeWjYeg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
To: Vipul Pandya <vipul@chelsio.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/infiniband/hw/cxgb4/device.c
> b/drivers/infiniband/hw/cxgb4/device.c
> index c8fd1d8..cb4ecd7 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -32,6 +32,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/debugfs.h>
> +#include <linux/vmalloc.h>
>
>  #include <rdma/ib_verbs.h>

Thanks, I folded this into my pull request.
