Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1LMAsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:48:35 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:40809 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1LMAsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:48:32 -0500
Subject: Re: [PATCH v2] unicore32: standardize /proc/iomem "Kernel code"
 name
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20111212230429.GA25851@outflux.net>
References: <20111212230429.GA25851@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Tue, 13 Dec 2011 08:50:23 +0800
Message-ID: <1323737423.32086.18.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 15:04 -0800, Kees Cook wrote:
> All other ports use "Kernel code" to identify the Kernel text segment
> in /proc/iomem. Change the unicore32 resources to do the same.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks.
I have pushed this patch into my repo.

Guan Xuetao

> ---
> v2: Fixed my copy/paste-o.
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


