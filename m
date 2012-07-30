Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2G3Qgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:36:38 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60211 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab2G3Qgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:36:36 -0400
Message-ID: <5016B7B3.2040702@mvista.com>
Date: Mon, 30 Jul 2012 20:34:59 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: mfm@muteddisk.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]staging: usbip: Fix typos.
References: <1343658202-19083-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1343658202-19083-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/30/2012 06:23 PM, Justin P. Mattock wrote:

> From: "Justin P. Mattock" <justinmattock@gmail.com>

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

> ---

> The below patch fixes typos found while reading through staging: usbip

   Unfortunately, it introduces some new instead. :-)

> diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
> index 12a9a5f..dd15dc0 100644
> --- a/drivers/staging/usbip/vhci_hcd.c
> +++ b/drivers/staging/usbip/vhci_hcd.c
> @@ -828,11 +828,11 @@ static void vhci_shutdown_connection(struct usbip_device *ud)
>  	 *	disable endpoints. pending urbs are unlinked(dequeued).
>  	 *
>  	 * NOTE: After calling rh_port_disconnect(), the USB device drivers of a
> -	 * deteched device should release used urbs in a cleanup function(i.e.
> +	 * detached device should release used urbs in a cleanup function(i.e.

   Space is needed before "(i.e.".

>  	 * xxx_disconnect()). Therefore, vhci_hcd does not need to release
>  	 * pushed urbs and their private data in this function.
>  	 *
> -	 * NOTE: vhci_dequeue() must be considered carefully. When shutdowning
> +	 * NOTE: vhci_dequeue() must be considered carefully. When shuting down

   Shutting.

WBR, Sergei

