Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052Ab0HEKA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:00:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27390 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab0HEKAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:00:55 -0400
Date: Thu, 05 Aug 2010 12:02:22 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/2] usb gadget: don't save bind callback in struct
 usb_configuration
In-reply-to: <20100805094545.GB22207@pengutronix.de>
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-id: <op.vgyl58p17p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <20100802182521.GA4151@pengutronix.de>
 <1280773666-5405-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <op.vgyjjx1d7p4s8u@pikus> <20100805094545.GB22207@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Aug 05, 2010 at 11:05:47AM +0200, Michał Nazarewicz wrote:
>> Also note, that if you are fixing composite gadgets as well, there's also
>> usb_composite_driver structure and accompanying usb_composite_register()
>> function.

On Thu, 05 Aug 2010 11:45:46 +0200, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> This is ortogonal to my two patches, right?  Will look into it later.

Yep.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
