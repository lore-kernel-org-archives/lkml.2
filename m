Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab1D0PRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:17:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:45183 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933048Ab1D0PRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:17:53 -0400
Date: Wed, 27 Apr 2011 08:06:51 -0700
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 8/8] staging/mei: Updates to staging/Kconfig ane
 staging/Makefile and a new Makefile and Kconfig
Message-ID: <20110427150651.GD24596@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-9-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303900057-21694-9-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:27:37PM +0300, Oren Weil wrote:
> --- /dev/null
> +++ b/drivers/staging/mei/Kconfig
> @@ -0,0 +1,10 @@
> +config INTEL_MEI
> +	tristate "Intel Management Engine Interface (Intel MEI)"
> +	depends on X86 && EXPERIMENTAL

You need a lot more dependencies here, please fix this.

> +	help
> +		The Intel Management Engine (Intel ME) provides Manageability,
> +		Security and Media services for system containing Intel chipsets.
> +		if selected /dev/mei misc device will be created.
> +
> +		For more information see
> +		<http://software.intel.com/en-us/manageability/>
> diff --git a/drivers/staging/mei/Makefile b/drivers/staging/mei/Makefile
> new file mode 100644
> index 0000000..21a5088
> --- /dev/null
> +++ b/drivers/staging/mei/Makefile
> @@ -0,0 +1,20 @@
> +#
> +# Makefile - Intel Management Engine Interface (Intel MEI) Linux driver
> +# Copyright (c) 2010-2011, Intel Corporation.
> +#
> +# This program is free software; you can redistribute it and/or modify it
> +# under the terms and conditions of the GNU General Public License,
> +# version 2, as published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope it will be useful, but WITHOUT
> +# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> +# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> +# more details.
> +#

This is not a program, it is a Makefile, this header can be removed.

thanks,

greg k-h
