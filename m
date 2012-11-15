Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768703Ab2KOSqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:46:17 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:35178 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768600Ab2KOSqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:46:16 -0500
Date: Thu, 15 Nov 2012 18:46:15 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Igor Mazanov <i.mazanov@gmail.com>, mturquette@ti.com
cc: linux-omap@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove inline from clock framework function definitions
 to build the kernel with GCC 4.7
In-Reply-To: <50A52134.2010502@gmail.com>
Message-ID: <alpine.DEB.2.00.1211151845050.18192@utopia.booyaka.com>
References: <50A52134.2010502@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Mike

On Thu, 15 Nov 2012, Igor Mazanov wrote:

>  Remove inline from clock framework function definitions to
>  build the kernel with GCC 4.7

sparse warns about this also.

> Signed-off-by: Igor Mazanov <i.mazanov@gmail.com>

This one is for Mike to deal with as CCF maintainer; it's out of the hands 
of the OMAP folks.

Acked-by: Paul Walmsley <paul@pwsan.com>


> ---
>  include/linux/clk-provider.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index c127315..f9f5e9e 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -335,8 +335,8 @@ const char *__clk_get_name(struct clk *clk);
>  struct clk_hw *__clk_get_hw(struct clk *clk);
>  u8 __clk_get_num_parents(struct clk *clk);
>  struct clk *__clk_get_parent(struct clk *clk);
> -inline int __clk_get_enable_count(struct clk *clk);
> -inline int __clk_get_prepare_count(struct clk *clk);
> +int __clk_get_enable_count(struct clk *clk);
> +int __clk_get_prepare_count(struct clk *clk);
>  unsigned long __clk_get_rate(struct clk *clk);
>  unsigned long __clk_get_flags(struct clk *clk);
>  int __clk_is_enabled(struct clk *clk);
> --
> 1.7.4.4
> 


- Paul
