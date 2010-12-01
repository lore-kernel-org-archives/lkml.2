Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0LABCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:02:34 -0500
Received: from kroah.org ([198.145.64.141]:59745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab0LABCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:02:33 -0500
Date: Tue, 30 Nov 2010 16:56:47 -0800
From: Greg KH <greg@kroah.com>
To: David Sin <davidsin@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lajos Molnar <molnar@ti.com>
Subject: Re: [RFC v2 8/8] TILER-DMM: Linking TILER driver into the Linux
 kernel build
Message-ID: <20101201005647.GC29171@kroah.com>
References: <1291147139-23472-1-git-send-email-davidsin@ti.com>
 <1291147139-23472-9-git-send-email-davidsin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291147139-23472-9-git-send-email-davidsin@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 01:58:59PM -0600, David Sin wrote:
> From: Lajos Molnar <molnar@ti.com>
> 
> This patch links the TILER driver into the Linux kernel build
> and config system.
> 
> Signed-off-by: Lajos Molnar <molnar@ti.com>
> Signed-off-by: David Sin <davidsin@ti.com>
> ---
>  drivers/misc/Kconfig  |    5 +++++
>  drivers/misc/Makefile |    1 +
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index ac6d6ac..fff7927 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -378,4 +378,9 @@ source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
>  source "drivers/misc/iwmc3200top/Kconfig"
>  
> +#
> +# TI TILER driver support
> +#

Comments not needed.

thanks,

greg k-h
