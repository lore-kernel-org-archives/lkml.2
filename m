Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2HXOPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:15:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39110 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab2HXOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:15:37 -0400
Date: Fri, 24 Aug 2012 22:16:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de
Subject: Re: [PATCH 0/5] Add device tree support for on-chip SRAM
Message-ID: <20120824141610.GG31998@S2101-09.ap.freescale.net>
References: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:17:41AM +0200, Philipp Zabel wrote:
> These patches add support to configure the on-chip SRAM via device-tree
> node and to obtain the resulting genalloc pool from a phandle pointing   
> at the node.
> This allows drivers to allocate SRAM with the genalloc API without
> hard-coding the genalloc pool address.
> 
It looks like a good stuff.  But in the end, there is nothing IMX
specific with iram_alloc.c.  Why do we name it in IMX?

Regards,
Shawn

> regards
> Philipp
> 
> ---
>  arch/arm/boot/dts/imx53.dtsi          |    5 ++
>  arch/arm/boot/dts/imx6q.dtsi          |    5 ++
>  arch/arm/plat-mxc/include/mach/iram.h |   41 -----------------
>  arch/arm/plat-mxc/iram_alloc.c        |   81 ++++++++++++++++++++-------------
>  include/linux/genalloc.h              |   14 ++++++
>  lib/genalloc.c                        |   77 +++++++++++++++++++++++++++++++
>  6 files changed, 150 insertions(+), 73 deletions(-)
> 
