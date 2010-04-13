Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0DMTpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:45:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47621 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab0DMTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:45:06 -0400
Date: Tue, 13 Apr 2010 20:44:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       s.hauer@pengutronix.de, grant.likely@secretlab.ca,
       r.herring@freescale.com, linux-arm-kernel@lists.infradead.org,
       daniel@caiaq.de, bryan.wu@canonical.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 1/8] mx5: Add registration of GPIOs for MX51
	Babbage board.
Message-ID: <20100413194454.GB6289@n2100.arm.linux.org.uk>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:10:24AM -0500, Dinh.Nguyen@freescale.com wrote:
> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> index d6fd396..73f2342 100644
> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com>
> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
>   *
>   * The code contained herein is licensed under the GNU General Public
>   * License. You may obtain a copy of the GNU General Public License
> @@ -11,7 +12,9 @@
>  
>  #include <linux/platform_device.h>
>  #include <mach/hardware.h>
> +#include <mach/gpio.h>

linux/gpio.h
