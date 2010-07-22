Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0GVO0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:26:42 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11370 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0GVO0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:26:41 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 22 Jul 2010 16:28:03 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: core: Choose configuration with lowest
 bConfigurationValue
In-reply-to: <Pine.LNX.4.44L0.1007221020440.1725-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Adam Kropelin <akropel1@rochester.rr.com>,
        Xiaofan Chen <xiaofanc@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <op.vf80412e7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007221020440.1725-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Jul 2010, Michal Nazarewicz wrote:
>> This patch removes code from usb_choose_configuration()
>> responsible for ignoring the first USB device configuration if
>> its first interface is RNDIS.  Instead,
>> usb_choose_configuration() chooses configuration with lowest
>> bConfigurationValue.  Linux' Ethernet gadget uses a lower
>> bConfigurationValue for the second configuration which is
>> a CDC configuration so this code should choose configuration
>> that suits Linux better.

On Thu, 22 Jul 2010 16:22:37 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> I don't like this idea.  Choosing configs is a sensitive topic, since
> it is highly visible to users.  It should be changed minimally, if at
> all.

Fine by me.  I've just posted it to show what I had in mind.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
