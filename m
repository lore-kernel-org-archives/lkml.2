Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674Ab0HFIpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:45:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51936 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab0HFIpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:45:18 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 06 Aug 2010 10:46:50 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/2 v2] usb gadget: don't save bind callback in struct
 usb_configuration
In-reply-to: <20100805223435.GC18619@kroah.com>
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-id: <op.vg0dccfk7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <op.vgyjjx1d7p4s8u@pikus>
 <1281001817-7807-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20100805223435.GC18619@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Aug 2010 00:34:35 +0200, Greg KH <greg@kroah.com> wrote:

> On Thu, Aug 05, 2010 at 11:50:17AM +0200, Uwe Kleine-König wrote:
>> The bind function is most of the time only called at init time so there is no
>> need to save a pointer to it in the configuration structure.
>>
>> This fixes many section mismatches reported by modpost.
>>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> Cc: Michał Nazarewicz <m.nazarewicz@samsung.com>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> ---
>> changes since v1:
>
> I'm confused, can you resend what you want me to apply please?
>
> Do I need to drop Michał's patch before applying yours?

Yep.  Uwe's patches seem to be a better solution for fixing the section
mismatch.  They remove the need of __ref* tags.  I looked through them
and they seem fine to me.

(Also, as I realised a minute ago, my patch is incorrect.)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
