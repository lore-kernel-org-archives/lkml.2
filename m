Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab2E3Oz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:55:29 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34028 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241Ab2E3Oz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <1338375394-16268-4-git-send-email-kishon@ti.com>
References: <1338375394-16268-1-git-send-email-kishon@ti.com> <1338375394-16268-4-git-send-email-kishon@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 30 May 2012 20:25:05 +0530
Message-ID: <CAMQu2gw8-ZuKqTVaqZtcvD4K5iGVPJKj9u9j4K8SFrUm7qb7fg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] drivers: misc: omap: add a new driver for ocp2scp
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 4:26 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Adds a new driver _ocp2scp_. This driver takes the responsibility of creating
> all the devices that is connected to OCP2SCP. In the case of OMAP4, USB2PHY
> is connected to ocp2scp.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
[...]

> +++ b/drivers/misc/omap-ocp2scp.c
> @@ -0,0 +1,135 @@
> +/*
> + * omap-ocp2scp.c - transform ocp interface protocol to scp protocol
> + *
> + * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
s/2011/2012

[...]

> diff --git a/include/linux/platform_data/omap_ocp2scp.h b/include/linux/platform_data/omap_ocp2scp.h
> new file mode 100644
> index 0000000..dcbbf2a
> --- /dev/null
> +++ b/include/linux/platform_data/omap_ocp2scp.h
> @@ -0,0 +1,31 @@
> +/*
> + * omap_ocp2scp.h -- ocp2scp header file
> + *
> + * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
Dito.
