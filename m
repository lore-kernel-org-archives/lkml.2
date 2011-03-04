Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652Ab1CDOWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:22:25 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:55632 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab1CDOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:22:24 -0500
Date: Fri, 4 Mar 2011 15:20:28 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        tglx@linutronix.de, sshtylyov@mvista.com, arnd@arndb.de,
        amit.chatterjee@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 1/1] PRUSS UIO driver support
Message-ID: <20110304142028.GD28175@local>
References: <1299213772-21931-1-git-send-email-pratheesh@ti.com>
 <1299213772-21931-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299213772-21931-2-git-send-email-pratheesh@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 10:12:52AM +0530, Pratheesh Gangadhar wrote:
> diff --git a/include/linux/uio_pruss.h b/include/linux/uio_pruss.h
> new file mode 100644
> index 0000000..8c9b2c9
> --- /dev/null
> +++ b/include/linux/uio_pruss.h

That should go to arch/arm/mach-davinci/include/mach/
and not to the top level include/linux/ directory.

> @@ -0,0 +1,25 @@
> +/*
> + * include/linux/uio_pruss.h
> + *
> + * Platform data for uio_pruss driver
> + *
> + * Copyright (C) 2010-11 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _UIO_PRUSS_H_
> +#define _UIO_PRUSS_H_
> +
> +/* Used to configure the PRUSS INTC base offset for UIO driver */
> +struct uio_pruss_pdata {
> +	u32	pintc_base;
> +};
> +#endif /* _LINUX_UIO_PRUSS_H_ */
> -- 
> 1.6.0.6
> 
> 

Thanks,
Hans

