Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796Ab0GSRUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:20:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29521 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760789Ab0GSRUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:20:38 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 19 Jul 2010 19:21:57 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <Pine.LNX.4.44L0.1007191256480.1657-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Message-id: <op.vf3o6v067p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007191256480.1657-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 19:06:32 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
>> 1/3: http://lkml.org/lkml/2010/7/8/317

> Ah, yes.  My personal taste would be to write fsg_string_serial_fill_n
> as an inline routine instead of as a macro, and not try to make it
> separate from fsg_string_serial_fill.

>> 2/3: http://lkml.org/lkml/2010/7/8/318

> I have only one objection to this patch: The new parameter's name
> should be "serial", not "serial_parm".  (Compare it to all the other
> parameter names.)

Will change the two tomorrow.

> As for the discussion between you and David...  I haven't tried to
> follow the details very carefully.  I get the impression that the two
> of you are talking past each other instead of coming to grips with a
> genuine issue.

I'm not entirely sure of what the issue with the patches is really.
It merely adds a serial number to the gadgets using MSF and that's all.

In any event, I am sure we will come to an agreement at one point. :)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
