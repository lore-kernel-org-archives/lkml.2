Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1BQJek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 04:34:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48425 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1BQJei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 04:34:38 -0500
Date: Thu, 17 Feb 2011 09:34:33 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        arnd@arndb.de
Subject: Re: [PATCH V3 1/4] ARM: Xilinx: Adding Xilinx board support
Message-ID: <20110217093433.GB22961@pulham.picochip.com>
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com>
 <ad969bd6-87bb-4910-a04a-d680e90d69af@VA3EHSMHS009.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad969bd6-87bb-4910-a04a-d680e90d69af@VA3EHSMHS009.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

One nitpick, otherwise looks nice.

Jamie

On Wed, Feb 16, 2011 at 09:11:53AM -0700, John Linn wrote:
> diff --git a/arch/arm/mach-xilinx/common.h b/arch/arm/mach-xilinx/common.h
> new file mode 100644
> index 0000000..9a7cf65
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/common.h
> @@ -0,0 +1,30 @@
> +/* arch/arm/mach-xilinx/common.h
> + *
> + * This file contains common function prototypes to avoid externs
> + * in the c files.
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
> +#ifndef __MACH_XILINX_COMMON_H__
> +#define __MACH_XILINX_COMMON_H__
> +
> +#include <linux/init.h>
> +#include <linux/platform_device.h>

You don't appear to use the contents of platform_device.h in here so you 
could probably drop this include.
