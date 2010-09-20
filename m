Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab0ITRFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:05:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11779 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab0ITRFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:05:34 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 20 Sep 2010 19:07:28 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] net: core: dev.c: use spin_lock_irqsave() rather than
In-reply-to: <20100920.091407.241426689.davem@davemloft.net>
To: eric.dumazet@gmail.com, David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Message-id: <op.vjcciqgk7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <ee14e5e38e7a5df520d902ef8a236bbe9ed206fa.1284991149.git.m.nazarewicz@samsung.com>
 <1284998621.3420.539.camel@edumazet-laptop>
 <20100920.091407.241426689.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 18:14:07 +0200, David Miller <davem@davemloft.net> wrote:

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 20 Sep 2010 18:03:41 +0200
>
>> Hmm, while your patch is technically correct, it seems strange all this
>> stuff runs in hard irq context.
>
> I would much rather this RNDIS query response handler get
> scheduled to run into softirq context or similar instead.
>
> I am not applying this patch.

Eh...  I'll try to look at RNDIS than.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
