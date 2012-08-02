Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2HBMpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:45:10 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:41629 "EHLO
	homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753720Ab2HBMpI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=references
	:in-reply-to:mime-version:content-transfer-encoding:content-type
	:message-id:cc:from:subject:date:to; q=dns; s=shealevy.com; b=ZU
	Df1Wkln0/V/9ZxejC9488XyT67qijKP6ZJteQfF0G9B/8zGA8q4GzmCtAi3oQw+K
	ipuGS1fQS10UyBieo6+QqTMpr8wHKKwmvQhKHxnIY0aCqfp7cqJ+Qb+TQcNBirBw
	RiY/C8GfvaQCU4Jf9Su7Ef+TFnoB5Lqq3y4HUDMdY=
References: <1343911365-3376-1-git-send-email-shea@shealevy.com>
In-Reply-To: <1343911365-3376-1-git-send-email-shea@shealevy.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <6FC304BB-1C26-4A60-A797-309CC7506626@shealevy.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (9B206)
From: Shea Levy <shea@shealevy.com>
Subject: Re: [PATCH] Bluetooth: Add support for Apple MacBook Pro 9,2
Date: Thu, 2 Aug 2012 08:45:07 -0400
To: "shea@shealevy.com" <shea@shealevy.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, sorry, forgot the sign-off. Will resend after checkpatch passes. Sorry for the noise.

On Aug 2, 2012, at 8:42 AM, shea@shealevy.com wrote:

> From: Shea Levy <shea@shealevy.com>
> 
> ---
> drivers/bluetooth/btusb.c | 3 +++
> 1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index e272214..e4ecd5e 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -73,6 +73,9 @@ static struct usb_device_id btusb_table[] = {
>    /* Apple MacBookPro8,2 */
>    { USB_DEVICE(0x05ac, 0x821a) },
> 
> +    /* Apple MacBookPro9,2 */
> +    { USB_DEVICE(0x05ac, 0x821d) },
> +
>    /* Apple MacMini5,1 */
>    { USB_DEVICE(0x05ac, 0x8281) },
> 
> -- 
> 1.7.11
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
