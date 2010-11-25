Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0KYWxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 17:53:39 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41077 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab0KYWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 17:53:39 -0500
Date: Thu, 25 Nov 2010 23:53:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH 02/11] x86: Add device tree support
Message-ID: <20101125225337.GA21223@merkur.ravnborg.org>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290706801-7323-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
> new file mode 100644
> index 0000000..8fdb0d2
> --- /dev/null
> +++ b/arch/x86/include/asm/prom.h
> @@ -0,0 +1,60 @@
> +/*
> + * Definitions for Device tree / OpenFirmware handling on X86
> + *
> + * based on arch/powerpc/include/asm/prom.h which is
> + *         Copyright (C) 1996-2005 Paul Mackerras.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#ifndef _ASM_X86_PROM_H
> +#define _ASM_X86_PROM_H
> +#ifdef __KERNEL__

This file is not exported to userspace - so no need to guard with __KERNEL__

	Sam
