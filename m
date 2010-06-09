Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0FIKPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:15:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56854 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab0FIKPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:15:12 -0400
Date: Wed, 09 Jun 2010 12:15:57 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv4 10/13] USB: gadget: g_multi: more configurable
In-reply-to: <778712.18431.qm@web180308.mail.gq1.yahoo.com>
To: linux-usb@vger.kernel.org, David Brownell <david-b@pacbell.net>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vd02svmj7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.53 (Linux)
References: <778712.18431.qm@web180308.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 6/7/10, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
>> Added Kconfig options for each function used by g_multi so that
>> one can customize the gadget to a greater extend.

On Tue, 08 Jun 2010 15:37:24 +0200, David Brownell <david-b@pacbell.net> wrote:
> For what it's worth ... I still NAK all
> these complications to what's been intended
> to be a simple driver.

First of, let me assure you that I didn't want to “go behind your back” or
anything.

After your initial NAK I wouldn't bother resending this patch but I wanted
to show the install mode feature and stimulate some, I don't know, discussion
on how you see things go from here.  Sorry if I haven't been clear about
my intend.

Also note, that in my opinion all the previous patches in the patchset
should be considered all right in this regard since they don't add
complexity to the g_multi.

> If you want to create some complex monstrosity,
> that should have been a different driver.

So, what would you like to see happen?

As I'm working on various features for USB gadgets at the moment I wanted
to release them as quickly as possible.  Also, new ideas arise long after
the original gadget had been created.

Would you prefer I forked g_multi to a g_monstrosity gadget where new
features could be developed and tested?

Or do you think that such an experimental, dynamically changed gadget
has no place in kernel at all?  I don't like that idea as I'd like to
share the install mode and maybe other new features with the rest of
the word rather then keeping it on my hard drive.

Also, I think that having a configurable gadget may help others test their
platform and came up with a gadget they'd like to use by simply changing
Kconfig options and testing rather then hacking the file by themselves.

I wanted to reuse g_multi as to not create too many gadgets hence adding
features to g_multi in backward compatible fashion.

I'd like to hear you elaborate an that a little so I'd know what's the
best course of action here and what I should do from here.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
