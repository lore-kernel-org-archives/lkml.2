Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab0GTIk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 04:40:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10206 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab0GTIk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 04:40:28 -0400
Date: Tue, 20 Jul 2010 10:41:46 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <463626.69698.qm@web180301.mail.gq1.yahoo.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Message-id: <op.vf4vrwa67p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <463626.69698.qm@web180301.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 19:41:10 +0200, David Brownell <david-b@pacbell.net> wrote:
>> I'm not entirely sure of what the issue with
>> the patches is really. It merely adds a serial
>> number to the gadgets using MSF and that's all.
>
> Go back and read what I wrote then.  The issue is
> that THERE ALREADY IS SUCH A MECHANISM.  We neither
> need or want another way to do it.  The answer is to
> use the existing mechanism correctly.

There is no existing mechanism.  If the module does not set the
iSerialNumber field the iSerialNumber module parameter won't work
and I don't see any other way to set the string.  If there is one,
please show it to me.

> Plus, you seem to be overlooking the basic need
> (for userspace) to manage these IDs so they're
> properly unique.  Two gadgets should never end up
> using the same serial number.

I'm not overlooking that.  I simply consider that a separate issue.
Driver should provide some kind of default (just like File Storage
Gadget) and the fact that user space should override it is another
matter in my opinion.

This is especially true, since the iSerialNumber module parameter
won't work without iSerialNumber set (which I pointed several
times).

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
