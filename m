Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2ENSOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:14:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47963 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2ENSOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:14:17 -0400
References: <4FB12E00.4050104@solcon.nl>
In-Reply-To: <4FB12E00.4050104@solcon.nl>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <92132DC1-8B29-4059-B768-3AF17216F472@gmail.com>
Cc: "IvDoorn@gmail.com" <IvDoorn@gmail.com>,
        "helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (9B206)
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2800usb: 2001:3c17 is an RT3370 device
Date: Mon, 14 May 2012 20:14:13 +0200
To: Albert Pool <albertpool@solcon.nl>, John Linville <linville@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 mei 2012, at 18:08, Albert Pool <albertpool@solcon.nl> wrote:

> D-Link DWA-123 rev A1
> 
> Signed-off-by: Albert Pool<albertpool@solcon.nl>

Cc: <stable@vger.kernel.org>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800usb.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 262ee9e..6ee4051 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1070,6 +1070,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
> #ifdef CONFIG_RT2800USB_RT33XX
>    /* Belkin */
>    { USB_DEVICE(0x050d, 0x945b) },
> +    /* D-Link */
> +    { USB_DEVICE(0x2001, 0x3c17) },
>    /* Ralink */
>    { USB_DEVICE(0x148f, 0x3370) },
>    { USB_DEVICE(0x148f, 0x8070) },
> @@ -1145,7 +1147,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>    /* D-Link */
>    { USB_DEVICE(0x07d1, 0x3c0b) },
>    { USB_DEVICE(0x07d1, 0x3c17) },
> -    { USB_DEVICE(0x2001, 0x3c17) },
>    /* Edimax */
>    { USB_DEVICE(0x7392, 0x4085) },
>    /* Encore */
> -- 
> 1.7.9
> 
> 
