Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935798Ab0GSPAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:00:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22094 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935221Ab0GSPAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:00:38 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 19 Jul 2010 17:01:55 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <583384.61837.qm@web180312.mail.gq1.yahoo.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Message-id: <op.vf3iphex7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <583384.61837.qm@web180312.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> As you see, the iSerialNumber module parameter
>> is ignored unless the
>> gadget driver sets the iSerialNumber field of
>> the device descriptor.

On Mon, 19 Jul 2010 16:44:55 +0200, David Brownell <david-b@pacbell.net> wrote:
> So make that gadget code do that ...

That's exactly what I have done.  I have added a code that sets
the iSerialNumber.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
