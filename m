Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1BOUkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 15:40:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45798 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1BOUkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 15:40:15 -0500
Date: Tue, 15 Feb 2011 13:40:11 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: glikely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        John Williams <john.williams@petalogix.com>
Subject: Re: [PATCH] of: Add missing of_address.h to xilinx ehci driver
Message-ID: <20110215204011.GB24022@angua.secretlab.ca>
References: <1297680009-4054-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297680009-4054-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:40:09AM +0100, Michal Simek wrote:
> Build log:
> In file included from drivers/usb/host/ehci-hcd.c:1208:
> drivers/usb/host/ehci-xilinx-of.c: In function 'ehci_hcd_xilinx_of_probe':
> drivers/usb/host/ehci-xilinx-of.c:168: error: implicit declaration of function 'of_address_to_resource'
> 
> Signed-off-by: John Williams <john.williams@petalogix.com>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Applied, thanks.

g.

> ---
>  drivers/usb/host/ehci-xilinx-of.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
> index e8f4f36..a6f21b8 100644
> --- a/drivers/usb/host/ehci-xilinx-of.c
> +++ b/drivers/usb/host/ehci-xilinx-of.c
> @@ -29,6 +29,7 @@
>  
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/of_address.h>
>  
>  /**
>   * ehci_xilinx_of_setup - Initialize the device for ehci_reset()
> -- 
> 1.5.5.6
> 
