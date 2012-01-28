Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2A1PU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:20:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63300 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2A1PU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:20:26 -0500
Message-ID: <4F2411F4.6040403@mvista.com>
Date: Sat, 28 Jan 2012 19:19:16 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jos=E9_Antonio_Matute?= <matutet@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qcserial: add support for Huawei Gobi 3000 devices
References: <CAFQ_mD6DThCcsvy5=A0sMVBn-1mhwyTeGsM8GpSS__5zDU6K-A@mail.gmail.com>
In-Reply-To: <CAFQ_mD6DThCcsvy5=A0sMVBn-1mhwyTeGsM8GpSS__5zDU6K-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-01-2012 13:11, José Antonio Matute wrote:

> From: Jose Antonio Matute<matutet@gmail.com>

   Should be an empty line here, no?

> Add USB IDs for Huawei Gobi 3000 devices (some of which are rebranded
> as Sony Vaio VPCSA modems).

> Signed-off-by: Jose Antonio Matute<matutet@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> --- linux-3.3-rc1/drivers/usb/serial/qcserial.c.orig	2012-01-28
> 09:43:01.088140483 +0100
> +++ linux-3.3-rc1/drivers/usb/serial/qcserial.c	2012-01-28
> 09:46:37.908131967 +0100
> @@ -87,6 +87,7 @@ static const struct usb_device_id id_tab
>   	{USB_DEVICE(0x05c6, 0x9204)},	/* Gobi 2000 QDL device */
>   	{USB_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
>   	{USB_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem
> device (MC8355) */

    The patch is line wrapped; seems ealsy to fix tho...

> +	{USB_DEVICE(0x12d1, 0x14f1)},	/* Huawei Wireless Gobi 3000 Modem device */
>   	{ }				/* Terminating entry */
>   };
>   MODULE_DEVICE_TABLE(usb, id_table);

WBR, Sergei
