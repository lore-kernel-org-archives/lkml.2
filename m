Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1BNNyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:54:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48591 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1BNNy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:54:29 -0500
MIME-Version: 1.0
In-Reply-To: <1297680009-4054-1-git-send-email-monstr@monstr.eu>
References: <1297680009-4054-1-git-send-email-monstr@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 Feb 2011 06:54:08 -0700
X-Google-Sender-Auth: SgO3YVbbO6LgPB5YgpTdRJK-3sg
Message-ID: <AANLkTi=GZdX62bbMQhE81rbXO0MBdTK-pPbF61qEX3C+@mail.gmail.com>
Subject: Re: [PATCH] of: Add missing of_address.h to xilinx ehci driver
To: Michal Simek <monstr@monstr.eu>, Greg Kroah-Hartman <greg@kroah.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        John Williams <john.williams@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 3:40 AM, Michal Simek <monstr@monstr.eu> wrote:
> Build log:
> In file included from drivers/usb/host/ehci-hcd.c:1208:
> drivers/usb/host/ehci-xilinx-of.c: In function 'ehci_hcd_xilinx_of_probe':
> drivers/usb/host/ehci-xilinx-of.c:168: error: implicit declaration of function 'of_address_to_resource'
>
> Signed-off-by: John Williams <john.williams@petalogix.com>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Greg, let me know if you want me to pick this one up for my next pull req.

g.

> ---
>  drivers/usb/host/ehci-xilinx-of.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
> index e8f4f36..a6f21b8 100644
> --- a/drivers/usb/host/ehci-xilinx-of.c
> +++ b/drivers/usb/host/ehci-xilinx-of.c
> @@ -29,6 +29,7 @@
>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/of_address.h>
>
>  /**
>  * ehci_xilinx_of_setup - Initialize the device for ehci_reset()
> --
> 1.5.5.6
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
