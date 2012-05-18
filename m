Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967236Ab2ERT4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:56:30 -0400
Received: from mail.southpole.se ([193.12.106.18]:41445 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967137Ab2ERT43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:56:29 -0400
Message-ID: <1337370986.7558.22.camel@jerome.southpole.se>
Subject: Re: [patch 15/24] openrisc: Use generic time config
From: Jonas Bonn <jonas@southpole.se>
To: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 18 May 2012 21:56:26 +0200
In-Reply-To: <20120518163106.333611712@glx-um.de>
References: <20120518163020.548627576@glx-um.de>
	 <20120518163106.333611712@glx-um.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 70986-09536
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Good idea!

Acked-by: Jonas Bonn <jonas@southpole.se>

Thanks,
Jonas

On Fri, 2012-05-18 at 16:45 +0000, Anna-Maria Gleixner wrote:
> plain text document attachment
> (openrisc-use-generic-time-config.patch)
> Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
> Cc: Jonas Bonn <jonas@southpole.se>
> ---
>  arch/openrisc/Kconfig |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: linux/arch/openrisc/Kconfig
> ===================================================================
> --- linux.orig/arch/openrisc/Kconfig
> +++ linux/arch/openrisc/Kconfig
> @@ -17,6 +17,7 @@ config OPENRISC
>  	select GENERIC_IOMAP
>  	select GENERIC_CPU_DEVICES
>  	select GENERIC_ATOMIC64
> +	select GENERIC_CLOCKEVENTS
>  
>  config MMU
>  	def_bool y
> @@ -46,9 +47,6 @@ config NO_IOPORT
>  config GENERIC_GPIO
>  	def_bool y
>  
> -config GENERIC_CLOCKEVENTS
> -	def_bool y
> -
>  config TRACE_IRQFLAGS_SUPPORT
>          def_bool y
>  
> 
> 


