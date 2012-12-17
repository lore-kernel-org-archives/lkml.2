Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2LQPKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:10:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63317 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2LQPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:10:22 -0500
Date: Mon, 17 Dec 2012 07:13:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: alan@linux.intel.com, jslaby@suse.cz, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        swarren@wwwdotorg.org
Subject: Re: [PATCH] serial: tegra: add serial driver
Message-ID: <20121217151309.GA15665@kroah.com>
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 05:40:49PM +0530, Laxman Dewangan wrote:
> Nvidia's Tegra has multiple uart controller which supports:
> - APB dma based controller fifo read/write.
> - End Of Data interrupt in incoming data to know whether end
>   of frame achieve or not.
> - Hw controlled RTS and CTS flow control to reduce SW overhead.
> 
> Add serial driver to use all above feature.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  .../bindings/serial/nvidia,serial-tegra.txt        |   26 +
>  drivers/tty/serial/Kconfig                         |   14 +
>  drivers/tty/serial/Makefile                        |    1 +
>  drivers/tty/serial/serial_tegra.c                  | 1398 ++++++++++++++++++++
>  include/linux/serial_tegra.h                       |   33 +

This file should be in include/linux/platform_data/, right?

thanks,

greg k-h
