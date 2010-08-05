Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab0HEJEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:04:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39432 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab0HEJEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:04:16 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 05 Aug 2010 11:05:47 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/2] usb gadget: don't save bind callback in struct
 usb_configuration
In-reply-to: <1280773666-5405-2-git-send-email-u.kleine-koenig@pengutronix.de>
To: linux-usb@vger.kernel.org,
        =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Message-id: <op.vgyjjx1d7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <20100802182521.GA4151@pengutronix.de>
 <1280773666-5405-2-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 20:27:46 +0200, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> The bind function is only called at init time so there is no need to
> save a pointer to it in the driver struct.

This is not entirely true.  How about such wording:

   The bind function is often called only at init time so there is no neet
   to save a pointer to it in the configuration structure.

Also note, that if you are fixing composite gadgets as well, there's also
usb_composite_driver structure and accompanying usb_composite_register()
function.

Other then that, for what it's worth, the patch looks good to me.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
