Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab0HEKf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:35:59 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47046 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0HEKf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:35:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 05 Aug 2010 12:37:29 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 1/2] usb gadget: don't save bind callback in struct
 usb_gadget_driver
In-reply-to: <20100805093954.GA22207@pengutronix.de>
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-id: <op.vgynsrlu7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <20100802182521.GA4151@pengutronix.de>
 <1280773666-5405-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <op.vgyi8eix7p4s8u@pikus> <20100805093954.GA22207@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Aug 2010 11:39:54 +0200, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> On Thu, Aug 05, 2010 at 10:58:52AM +0200, Michał Nazarewicz wrote:
>> On Mon, 02 Aug 2010 20:27:45 +0200, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
>>> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
>>> @@ -2045,7 +2045,6 @@ static void __exit udc_exit(void)
>>>  }
>>> EXPORT_SYMBOL(usb_gadget_unregister_driver);
>>> -EXPORT_SYMBOL(usb_gadget_register_driver);
>>
>> *IF* you are going to send an updated patch, how about removing
>> empty line above this EXPORT_SYMBOL().

> I kept that, because the '}' doesn't belong to
> usb_gadget_unregister_driver.

In that case disregard my last comment. Move along, nothing to see. ;)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
