Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1EYILk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:11:40 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:53706 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab1EYILi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:11:38 -0400
Message-ID: <4DDCB96B.5000606@atmel.com>
Date: Wed, 25 May 2011 10:10:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
References: <201105181047.17309.arnd@arndb.de>
In-Reply-To: <201105181047.17309.arnd@arndb.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/05/2011 10:47, Arnd Bergmann :
> This is the draft plan for maintaining the ARM subarchitectures in a common
> tree, as a way to help coordinate the upstream merging of the
> arch/arm/{plat,mach}-* changes into Linus' tree.

[..]

> Maintainers: If you are happy with the layout of the process,
> please ack this patch, otherwise please comment.
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8fce5e6..942d052 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -630,6 +630,17 @@ S:	Maintained
>  F:	drivers/amba/
>  F:	include/linux/amba/bus.h
>  
> +ARM SUBARCHITECTURES
> +M:	Arnd Bergmann <arnd@arndb.de>
> +M:	Nicolas Pitre <nico@fluxnic.net>
> +M:	Thomas Gleixner <tglx@linutronix.de>
> +M:	arm@kernel.org

New alias needed?

> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	MAINTAINED
> +F:	arch/arm/mach-*/
> +F:	arch/arm/plat-*/
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-subarch.git

I like this initiative. Thanks to you guys for this effort!

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
(as co-maintainer of the Atmel AT91 subarchitecture)

Bye,
-- 
Nicolas Ferre

