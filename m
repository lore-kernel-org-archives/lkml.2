Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2KTMlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:41:19 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34076 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:41:18 -0500
MIME-Version: 1.0
In-Reply-To: <1443f143846f22125e3d6631cf3a2fdf75d925d3.1353349191.git.josh.cartwright@ni.com>
References: <cover.1353349191.git.josh.cartwright@ni.com>
	<1443f143846f22125e3d6631cf3a2fdf75d925d3.1353349191.git.josh.cartwright@ni.com>
Date: Tue, 20 Nov 2012 13:41:16 +0100
Message-ID: <CAHTX3dK2AEGh72XMuPSyBCV1sdM6jDvdiyPdh5VGXhTnwOqWTA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: zynq: remove TTC early mapping
From: Michal Simek <monstr@monstr.eu>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/19 Josh Cartwright <josh.cartwright@ni.com>:
> Now that the TTC driver has proper support for DT bindings, it is not
> necessary for the registers to be mapped early.  They will be mapped
> during clock initialization using of_iomap().  Remove the early mapping.
>
> In addition, remove the extraneous zynq_soc.h include from the timer
> driver.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  arch/arm/mach-zynq/common.c                | 5 -----
>  arch/arm/mach-zynq/include/mach/zynq_soc.h | 6 +-----
>  arch/arm/mach-zynq/timer.c                 | 1 -
>  3 files changed, 1 insertion(+), 11 deletions(-)

Tested-by: Michal Simek <michal.simek@xilinx.com>

Applied to xilinx arm-next branch.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
