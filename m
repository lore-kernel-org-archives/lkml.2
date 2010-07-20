Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab0GTPny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:43:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41707 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab0GTPnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:43:53 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 20 Jul 2010 17:45:13 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <289287.8629.qm@web180303.mail.gq1.yahoo.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Message-id: <op.vf5fdnc27p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <289287.8629.qm@web180303.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Plus, you seem to be overlooking the basic need
>>> (for userspace) to manage these IDs so they're
>>> properly unique.  Two gadgets should never end
>>> up using the same serial number

> --- On Tue, 7/20/10, Michał Nazarewicz <m.nazarewicz@samsung.com> wrote:
>> I'm not overlooking that.  I simply consider that a separate
>> issue. Driver should provide some kind of default.

On Tue, 20 Jul 2010 17:01:37 +0200, David Brownell <david-b@pacbell.net> wrote:
> It can't do that and guarantee uniqueness.

I never claimed otherwise.

> Your concept is (still/again) broken.

I don't buy that.  The driver works better with a non-unique
serial number then without any.  As such, a default serial
number should, in my opinion, be provided.

>> (just like File Storage Gadget) and the fact that user space
>> should override it is another matter in my opinion.

> The value must come from userspace in the first
> place, else it can't be correctly managed!!

I would say it *should* come from userspace but if userspace fails to
provide one *something* is better then *nothing*.  I see how gadgets
should print a warning if serial is not provided from user space but
other then that I still think gadget should provide some value.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
