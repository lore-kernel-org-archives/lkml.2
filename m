Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1B1LVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:21:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60352 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1B1LVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:21:08 -0500
Date: Mon, 28 Feb 2011 11:20:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, glikely@secretlab.ca, jamie@jamieiles.com,
        arnd@arndb.de
Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly
	macros
Message-ID: <20110228112055.GC29843@n2100.arm.linux.org.uk>
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <1298052881-14591-2-git-send-email-john.linn@xilinx.com> <1298052881-14591-3-git-send-email-john.linn@xilinx.com> <42efee69-aca1-446b-a997-f0063e113877@VA3EHSMHS009.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42efee69-aca1-446b-a997-f0063e113877@VA3EHSMHS009.ehs.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 11:14:40AM -0700, John Linn wrote:
> diff --git a/arch/arm/mach-xilinx/include/mach/uncompress.h b/arch/arm/mach-xilinx/include/mach/uncompress.h
> new file mode 100644
> index 0000000..ff3754c
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/include/mach/uncompress.h
> @@ -0,0 +1,61 @@
> +/* arch/arm/mach-xilinx/include/mach/uncompress.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_UNCOMPRESS_H__
> +#define __MACH_UNCOMPRESS_H__
> +
> +#include <mach/xilinx_soc.h>
> +#include <mach/uart.h>
> +#include <asm/processor.h>
> +#include <asm/io.h>
> +#include <mach/io.h>

You don't need mach/io.h here - it's already included by asm/io.h.
It's probably also worth trying linux/io.h instead of asm/io.h too.
