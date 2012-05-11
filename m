Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2EKLVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:21:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50984 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab2EKLV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:21:29 -0400
Message-ID: <4FACF61A.7070706@mvista.com>
Date: Fri, 11 May 2012 15:20:58 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: joseph daniel <josephdanielwalter@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/dwc3: Fix the dwc3 dependency
References: <1336715724-8441-1-git-send-email-josephdanielwalter@gmail.com>
In-Reply-To: <1336715724-8441-1-git-send-email-josephdanielwalter@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-05-2012 9:55, joseph daniel wrote:

> The warning shown up when ran with randconfig,

> warning: (USB_DWC3) selects USB_XHCI_PLATFORM which has unmet direct dependencies (USB_SUPPORT&&  USB_XHCI_HCD)

> Signed-off-by: joseph daniel<josephdanielwalter@gmail.com>
> ---
>   drivers/usb/dwc3/Kconfig |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index d8f741f..68271fa 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -1,6 +1,6 @@
>   config USB_DWC3
>   	tristate "DesignWare USB3 DRD Core Support"
> -	depends on (USB&&  USB_GADGET)
> +	depends on (USB&&  USB_SUPPORT&&  USB_XCHI_HCD&&  USB_GADGET)

    Parens not needed -- could as well get rid of them.

WBR, Sergei
