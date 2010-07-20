Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab0GTOmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:42:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39187 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab0GTOmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:42:38 -0400
Date: Tue, 20 Jul 2010 16:43:58 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <Pine.LNX.4.44L0.1007201005460.1631-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Message-id: <op.vf5cjk2e7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007201005460.1631-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 20 Jul 2010, [utf-8] MichaÅ‚ Nazarewicz wrote:
>> There is no existing mechanism.  If the module does not set the
>> iSerialNumber field the iSerialNumber module parameter won't work
>> and I don't see any other way to set the string.  If there is one,
>> please show it to me.

On Tue, 20 Jul 2010 16:07:35 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> That's clearly a bug.  Change the code so that a module parameter will
> always work, even if a function driver doesn't specify a serial number
> string.

Ah!  So that's what I wasn't getting!  I'll get to it then.  Will
send an updated v4 later this week (maybe today).

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
