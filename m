Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2DBTGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:06:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58937 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2DBTGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:06:01 -0400
Message-ID: <4F79F859.8080002@mvista.com>
Date: Mon, 02 Apr 2012 23:04:57 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: Kconfig fix display
References: <1333365230-15450-1-git-send-email-plagnioj@jcrosoft.com>
In-Reply-To: <1333365230-15450-1-git-send-email-plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04/02/2012 03:13 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:

> Move HAS option before menuconfig so the USB option will show in the sub menu
> and not the drivers menu.
> Introduce in commit 53c6bc24fdc8db87109a5760579cbb060fa644cf usb: Don't make
> USB_ARCH_HAS_{XHCI,OHCI,EHCI} depend on USB_SUPPORT.

> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD<plagnioj@jcrosoft.com>
> Cc: linux-usb@vger.kernel.org
> ---
>   drivers/usb/Kconfig |   16 ++++++++--------
>   1 files changed, 8 insertions(+), 8 deletions(-)

> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index cbd8f5f..76316a3 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -2,14 +2,6 @@
>   # USB device configuration
>   #
>
> -menuconfig USB_SUPPORT
> -	bool "USB support"
> -	depends on HAS_IOMEM
> -	default y
> -	---help---
> -	  This option adds core support for Universal Serial Bus (USB).
> -	  You will also need drivers from the following menu to make use of it.
> -
>   # many non-PCI SOC chips embed OHCI
>   config USB_ARCH_HAS_OHCI
>   	boolean
> @@ -63,6 +55,14 @@ config USB_ARCH_HAS_XHCI
>   	boolean
>   	default PCI
>
> +menuconfig USB_SUPPORT
> +	bool "USB support"
> +	depends on HAS_IOMEM
> +	default y
> +	---help---
> +	  This option adds core support for Universal Serial Bus (USB).
> +	  You will also need drivers from the following menu to make use of it.
> +
>   if USB_SUPPORT
>
>   config USB_COMMON

    Analogous patch has been already submitted by David Daney, author of the 
original breakage.

WBR, Sergei
