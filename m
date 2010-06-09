Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0FIIzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:55:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58025 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0FIIzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:55:15 -0400
Date: Wed, 09 Jun 2010 10:55:51 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv4 08/13] USB: gadget: g_serial: INF file updated
In-reply-to: <996015.66352.qm@web180311.mail.gq1.yahoo.com>
To: linux-usb@vger.kernel.org, David Brownell <david-b@pacbell.net>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vd0y3ds37p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.53 (Linux)
References: <996015.66352.qm@web180311.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010 15:13:30 +0200, David Brownell <david-b@pacbell.net> wrote:
>> +; Copyright (c) 2000 Microsoft Corporation
>
> Same comment as with the INF file for g_ether:
>
> If you're giving Microsoft credit for this,
> you should make sure we have the right to
> redistribute the changes ...
>
> To the extent that your patches reduce our
> ability to redistribute these INF files and
> thus use these drivers with MS-Windows ... NAK.
>
> It's my understanding that pulling fragments
> from INF files comes under "fair use" and
> thus copyright does not need to be assigned.
> Microsoft publishes these things with the
> expectation they'll be copied/pasted all over...

So you're saying that removing the copyright will be the way to go?
I kept it since it was not really pulling fragments the INF is the
whole template provided by Microsoft with some minor changes.

As for RNDIS INF file, my understanding is that since Microsoft provides
the template in a publicly available documentation we can assume that we
have the right to redistribute code based on it.

As for CDC ACM INF file, my understanding is similar except the template
is provided by Microchip rather then Microsoft itself.

I thought it's safer to leave the copyright notice and assume we have the
right to modify and redistribute rather then remove it and then be accused
of claiming other's copyright.

All lawyers in the room please rise hands? ;)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
