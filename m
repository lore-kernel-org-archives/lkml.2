Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1ETU7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:59:49 -0400
Received: from mail.perches.com ([173.55.12.10]:1804 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab1ETU7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:59:47 -0400
Subject: Re: [RFC] ARM Subarchitecture group maintainership
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <201105181047.17309.arnd@arndb.de>
References: <201105181047.17309.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 13:59:45 -0700
Message-ID: <1305925185.4209.86.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 10:47 +0200, Arnd Bergmann wrote:
> otherwise please comment.
> diff --git a/MAINTAINERS b/MAINTAINERS
> @@ -630,6 +630,17 @@ S:	Maintained
>  F:	drivers/amba/
>  F:	include/linux/amba/bus.h
>  
> +ARM SUBARCHITECTURES
> +M:	Arnd Bergmann <arnd@arndb.de>
> +M:	Nicolas Pitre <nico@fluxnic.net>
> +M:	Thomas Gleixner <tglx@linutronix.de>
> +M:	arm@kernel.org
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	MAINTAINED

Trivial.  Please use:

S:	Maintained


