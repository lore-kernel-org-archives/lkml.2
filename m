Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262Ab2HPQQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:16:13 -0400
Received: from antcom.de ([188.40.178.216]:36603 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789Ab2HPQQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:16:07 -0400
Message-ID: <502D1CC2.9020901@antcom.de>
Date: Thu, 16 Aug 2012 18:16:02 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de>
In-Reply-To: <502D1A49.20603@linutronix.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 06:05 PM, Sebastian Andrzej Siewior wrote:
>> --- linux-2.6.orig/drivers/usb/gadget/lpc32xx_udc.c
>> +++ linux-2.6/drivers/usb/gadget/lpc32xx_udc.c
>> @@ -2987,14 +2986,14 @@ static irqreturn_t lpc32xx_usb_vbus_irq(
>>       return IRQ_HANDLED;
>>   }
>>
>> -static int lpc32xx_start(struct usb_gadget_driver *driver,
>> -             int (*bind)(struct usb_gadget *))
>> +static int lpc32xx_start(struct usb_gadget *gadget,
>> +             struct usb_gadget_driver *driver)
>>   {
>> -    struct lpc32xx_udc *udc =&controller;
> 
> I assume controller is a global var created at probe time and could be
> removed now, right?

Yes!
