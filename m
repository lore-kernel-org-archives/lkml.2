Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0HRB07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:26:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10883 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0HRB0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:26:52 -0400
Date: Wed, 18 Aug 2010 03:26:03 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv8 04/13] USB: gadget: mass_storage: moved strings handling
 code to composite
In-reply-to: <Pine.LNX.4.44L0.1008132019440.23591-100000@netrider.rowland.org>
To: David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Message-id: <op.vhl0xpih7p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <Pine.LNX.4.44L0.1008132019440.23591-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010 02:23:42 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:

> On Fri, 13 Aug 2010, David Brownell wrote:
>
>> --- On Fri, 8/13/10, Alan Stern <stern@rowland.harvard.edu> wrote:
>> .> ... based on all
>> > the preceding discussion, I now think the best
>> > approach may be _never
>> > to make up a fake serial number.  Use the module
>> > parameter, if any, and
>> > otherwise issue a warning and don't have
>> > a serial number string
>> > descriptor (even though that violates the spec).
>>
>>
>> Agreed, and that's what I had asked for.  I didn't
>> see code faking up a serial ... did I miss such?
>
> That code has been present in g_file_storage since the beginning.
> There were some patches earlier which moved the code to a different
> location.  I guess you missed it.  The current round of patches doesn't
> touch that code.

Yep.  I originally moved code from g_file_storage to g_mass_storage (and
g_multi) but after David's objections the patches have been dropped so
currently only g_file_storage has this code.

>> If so, let's see a new patch with no faking.
>
> An extra patch or two would be needed to remove the fake-serial
> generation.

This should be a straightforward patch.  If no one else does it
I can post it but it may take up to a month for me to find the time
to work on it.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

