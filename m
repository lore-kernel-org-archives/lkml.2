Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0IVROy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:14:54 -0400
Received: from xenotime.net ([72.52.115.56]:53528 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753427Ab0IVROx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:14:53 -0400
Date: Wed, 22 Sep 2010 10:14:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: x0130808@ti.com
Cc: linux-kernel@vger.kernel.org, Raja Mani <raja_mani@ti.com>,
        Pramodh AG <pramodh_ag@ti.com>
Subject: Re: [RFC/PATCH 9/9] Staging:ti-st: Update Kconfig and Makefile for
Message-Id: <20100922101450.8abc7b7e.rdunlap@xenotime.net>
In-Reply-To: <1285156119-28531-10-git-send-email-x0130808@ti.com>
References: <1285156119-28531-1-git-send-email-x0130808@ti.com>
	<1285156119-28531-2-git-send-email-x0130808@ti.com>
	<1285156119-28531-3-git-send-email-x0130808@ti.com>
	<1285156119-28531-4-git-send-email-x0130808@ti.com>
	<1285156119-28531-5-git-send-email-x0130808@ti.com>
	<1285156119-28531-6-git-send-email-x0130808@ti.com>
	<1285156119-28531-7-git-send-email-x0130808@ti.com>
	<1285156119-28531-8-git-send-email-x0130808@ti.com>
	<1285156119-28531-9-git-send-email-x0130808@ti.com>
	<1285156119-28531-10-git-send-email-x0130808@ti.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 07:48:39 -0400 x0130808@ti.com wrote:

> From: Raja Mani <raja_mani@ti.com>
> 
> Add new menu option in Kconfig and compilation option in Makefile for
> TI FM driver.
> 
> Signed-off-by: Raja Mani <raja_mani@ti.com>
> Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
> Signed-off-by: Manjunatha Halli <x0130808@ti.com>
> ---
>  drivers/staging/ti-st/Kconfig  |    8 ++++++++
>  drivers/staging/ti-st/Makefile |    2 ++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/ti-st/Kconfig b/drivers/staging/ti-st/Kconfig
> index 1b264a3..7e48749 100644
> --- a/drivers/staging/ti-st/Kconfig
> +++ b/drivers/staging/ti-st/Kconfig
> @@ -23,4 +23,12 @@ config ST_BT
>  	  This makes use of shared transport line discipline core driver to
>  	  communicate with the BT core of the combo chip.
>  
> +config ST_FM
> +	tristate "fm driver for ST"
> +	depends on VIDEO_DEV

	depends on VIDEO_DEV && RFKILL

since TI_ST depends on RFKILL.

> +	select TI_ST
> +	help
> +	  This enables the FM driver for TI BT/FM/GPS combo devices

	End above sentence with '.', please.

> +	  This makes use of shared transport line discipline core driver to
> +	  communicate with the FM core of the combo chip.
>  endmenu



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
