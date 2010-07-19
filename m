Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935864Ab0GSPAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:00:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22836 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935696Ab0GSPAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:00:46 -0400
Date: Mon, 19 Jul 2010 17:02:05 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <Pine.LNX.4.44L0.1007191017400.1657-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Message-id: <op.vf3iprm37p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007191017400.1657-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 16:19:06 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:

>>> OK, so it should add a module param with the same
>>> name as used elsewhere ...

> On Mon, 19 Jul 2010, [utf-8] MichaÅ‚ Nazarewicz wrote:
>> I was going to propose that but file storage gadget uses names
>> different from composite anyway (ie. vendor and product instead of
>> idVendor and idProduct) so I dunno if it's worth it.  As a matter
>> of fact, "serial" seems to match the other names better.
>>
>> > makes sense to me.  I Alan Acks that patch, go for it.

>> I believe Alan already agreed on this patch.  I'm merely updating
>> it to use the changes introduced by my patch to mass storage and
>> g_multi.

> I have lost track of the current state of that patch.  When you finish
> updating it, please post it for my review.

This is still the v3 patchset (only the first two should be of
interest to you), still want me to resend?

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
