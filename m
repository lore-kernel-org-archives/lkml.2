Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936410Ab0GSQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 12:25:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27236 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936372Ab0GSQZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 12:25:28 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 19 Jul 2010 18:26:46 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <Pine.LNX.4.44L0.1007191212360.1657-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Message-id: <op.vf3mmwoa7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007191212360.1657-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> I have lost track of the current state of that patch.  When you finish
>>> updating it, please post it for my review.

> On Mon, 19 Jul 2010, Michal‚ Nazarewicz wrote:
>> This is still the v3 patchset (only the first two should be of
>> interest to you), still want me to resend?

On Mon, 19 Jul 2010 18:14:01 +0200, Alan Stern wrote:
> Or provide a URL for them in the mailing list archives.

1/3: http://lkml.org/lkml/2010/7/8/317
	Adds serial to mass storage gadget and g_multi introducing
	fsg_string_serial_fill() macro used by abovementioned
	gadgets and file storage gadget.

2/3: http://lkml.org/lkml/2010/7/8/318
	Modification of Yann Cantin's patch, delta in comment for 1/3.

3/3: http://lkml.org/lkml/2010/7/8/316
	Modification of patch for earlier patch for g_multi.  Dunno if
	you want to look at it.  Providing URL for completeness.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
