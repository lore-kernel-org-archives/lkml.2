Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1LJKWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 05:22:43 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:54061 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1LJKWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 05:22:41 -0500
Subject: Re: [PATCH] unicore32: standardize /proc/iomem "Kernel code" name
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20111209211346.GA2639@outflux.net>
References: <20111209211346.GA2639@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Sat, 10 Dec 2011 18:24:22 +0800
Message-ID: <1323512662.1816.115.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 13:13 -0800, Kees Cook wrote:
> All other ports use "Kernel code" to identify the Kernel text segment
> in /proc/iomem. Change the ARM resources to do the same.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks Cook.

Our architecture/ISA is unicore32, not arm.

Guan Xuetao

> ---
>  arch/unicore32/kernel/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
> index 471b6bc..2a64061 100644
> --- a/arch/unicore32/kernel/setup.c
> +++ b/arch/unicore32/kernel/setup.c
> @@ -64,7 +64,7 @@ static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
>   */
>  static struct resource mem_res[] = {
>  	{
> -		.name = "Kernel text",
> +		.name = "Kernel code",
>  		.start = 0,
>  		.end = 0,
>  		.flags = IORESOURCE_MEM
> -- 
> 1.7.5.4
> 
> 


