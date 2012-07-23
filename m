Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2GWK0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 06:26:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64201 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2GWK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 06:26:34 -0400
Message-ID: <500D26A1.50500@mvista.com>
Date: Mon, 23 Jul 2012 14:25:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: kyak <bas@bmail.ru>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] USB: plusb: Add support for PL-2501
References: <alpine.LNX.2.02.1207222138410.1183@bas>
In-Reply-To: <alpine.LNX.2.02.1207222138410.1183@bas>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-07-2012 21:42, kyak wrote:

> From: Mikhail Peselnik <peselnik@gmail.com>

> This patch adds support for PL-2501 by adding the appropriate USB
> ID's. This chip is used in several USB 'Easy Trasfer' Cables.

> Signed-off-by: Mikhail Peselnik <peselnik@gmail.com>
> Tested-by: Mikhail Peselnik <peselnik@gmail.com>
> ---
> Now with proper sign-offs and right people in cc.
> plusb driver (drivers/net/usb/plusb.c) doesn't recognize PL2501 chip.
> Since PL2501 uses the same code as PL2301/PL2302 (PL2501 works in
> compatibility mode with PL2301/PL2302), the fix is trivial and
> attached as a patch.

> Just to note: the patch is not mine, it can be found here and there on
> Internet.
> I've tested the patch and it works great.

> Thank you.

> --- linux-3.5/drivers/net/usb/plusb.c.orig      2012-07-22
> 21:06:41.905802795 +0400
> +++ linux-3.5/drivers/net/usb/plusb.c   2012-07-22 21:07:00.345552404 +0400
[...]
> @@ -158,5 +161,5 @@ static struct usb_driver plusb_driver =
>   module_usb_driver(plusb_driver);
>
>   MODULE_AUTHOR("David Brownell");
> -MODULE_DESCRIPTION("Prolific PL-2301/2302/25A1 USB Host to Host Link Driver");
> +MODULE_DESCRIPTION("Prolific PL-2301/2302/25A1/2501 USB Host to Host
> Link Driver");

    Your patch is line wrapped. Seeems easy to fix though...

WBR, Sergei

