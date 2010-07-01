Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab0GAOZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:25:31 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18208 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0GAOZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:25:30 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 01 Jul 2010 16:26:37 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: gadget: mass storage: use proper device class in
 device desc
In-reply-to: <Pine.LNX.4.44L0.1007011004370.1596-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.ve542ns17p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007011004370.1596-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 1 Jul 2010, Michal Nazarewicz wrote:
>> Each time I see the device descriptor of the File Storage Gadget
>> I wonder if it shouldn't be set to the real value rather then leaving
>> it as per interface.

On Thu, 01 Jul 2010 16:09:39 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> It should not be changed.

>> Is there a reason to leave it as per interface?

> See Table 4.1 in the USB Mass Storage Bulk-Only Transport
> specification and Table 3.1 in the CBI Transport specification.

Ha! Thanks for clarification.  Will have to look more careful through
the specs next time.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
