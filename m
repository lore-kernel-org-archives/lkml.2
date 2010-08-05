Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab0HEJj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:39:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58379 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951Ab0HEJj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:39:57 -0400
Date: Thu, 5 Aug 2010 11:39:54 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] usb gadget: don't save bind callback in struct
	usb_gadget_driver
Message-ID: <20100805093954.GA22207@pengutronix.de>
References: <20100802182521.GA4151@pengutronix.de> <1280773666-5405-1-git-send-email-u.kleine-koenig@pengutronix.de> <op.vgyi8eix7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vgyi8eix7p4s8u@pikus>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:58:52AM +0200, Michał Nazarewicz wrote:
> On Mon, 02 Aug 2010 20:27:45 +0200, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
>> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
>> @@ -2045,7 +2045,6 @@ static void __exit udc_exit(void)
>>  }
>> EXPORT_SYMBOL(usb_gadget_unregister_driver);
>> -EXPORT_SYMBOL(usb_gadget_register_driver);
>
> *IF* you are going to send an updated patch, how about removing
> empty line above this EXPORT_SYMBOL().
I kept that, because the '}' doesn't belong to
usb_gadget_unregister_driver.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
