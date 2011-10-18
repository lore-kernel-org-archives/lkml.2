Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab1JRDcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 23:32:05 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:54973 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1JRDcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 23:32:03 -0400
Subject: Re: [PATCH 06/21] unicore32: drop unused Kconfig symbols
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1318595291.6132.63.camel@x61.thuisdomein>
References: <1318595291.6132.63.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Tue, 18 Oct 2011 11:33:34 +0800
Message-ID: <1318908814.1789.27.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Paul.
I will push the patch into my repo.

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>


On Fri, 2011-10-14 at 14:28 +0200, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/unicore32/Kconfig.debug |   14 --------------
>  1 files changed, 0 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
> index ae2ec33..1a36262 100644
> --- a/arch/unicore32/Kconfig.debug
> +++ b/arch/unicore32/Kconfig.debug
> @@ -44,18 +44,4 @@ config DEBUG_OCD
>  	  Say Y here if you want the debug print routines to direct their
>  	  output to the UniCore On-Chip-Debugger channel using CP #1.
>  
> -config DEBUG_OCD_BREAKPOINT
> -	bool "Breakpoint support via On-Chip-Debugger"
> -	depends on DEBUG_OCD
> -
> -config DEBUG_UART
> -	int "Kernel low-level debugging messages via serial port"
> -	depends on DEBUG_LL
> -	range 0 1
> -	default "0"
> -	help
> -	  Choice for UART for kernel low-level using PKUnity UARTS,
> -	  should be between zero and one. The port must have been
> -	  initialised by the boot-loader before use.
> -
>  endmenu


