Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2K2DqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:46:09 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51259 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab2K2DqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:46:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121129144042.add4ee11c35fa8d5f5876282@canb.auug.org.au>
References: <20121129144042.add4ee11c35fa8d5f5876282@canb.auug.org.au>
Date: Thu, 29 Nov 2012 09:16:06 +0530
Message-ID: <CAKohpokZJqEvpDcZ8nf2d6DB1JXb=LB-8LY9OqT8REf0KjAOuQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 slave-dma tree
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2012 09:10, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> diff --cc drivers/dma/dw_dmac.c

>  +#ifdef CONFIG_OF
>  +static struct dw_dma_platform_data *
>  +__devinit dw_dma_parse_dt(struct platform_device *pdev)

Do we need a separate patch to fix this place? I believe yes.

> - static int __devinit dw_probe(struct platform_device *pdev)
> + static int dw_probe(struct platform_device *pdev)

Thanks for this.
