Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0FIPWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:22:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61467 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab0FIPWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:22:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 09 Jun 2010 17:22:58 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv4 08/13] USB: gadget: g_serial: INF file updated
In-reply-to: <20100609145946.GB20543@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Xiaofan Chen <xiaofanc@gmail.com>, linux-usb@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vd1g0kcc7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.53 (Linux)
References: <996015.66352.qm@web180311.mail.gq1.yahoo.com>
 <op.vd0y3ds37p4s8u@pikus>
 <AANLkTim6GHWVNvZ1XOJBZiu7ltl7TVpVJwVltLoKpYRi@mail.gmail.com>
 <op.vd014urd7p4s8u@pikus> <20100609145946.GB20543@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I dunno, obviously I want to make everything according to law to avoid
>> any problems.  Maybe we should contact someone at The Software Freedom
>> Law Center or some similar entity?

On Wed, 09 Jun 2010 16:59:46 +0200, Greg KH <greg@kroah.com> wrote:
> Ick, no, that's not needed here.

Still I had a chat on IRC with a person who knows copyright law rather
well[1] which pointed me to a few things. ;)


> Take the copyright off if this is something that _you_ wrote.  If you
> copied it from somewhere and modified it, say where you copied it from,
> and show the rights that allowed you to copy it.
>
> Where exactly did you get it from originally?

The RNDIS template was taken from:
http://msdn.microsoft.com/en-us/library/ff570620.aspx

The CDC ACM was sent by Xiaofan Chen who said that it is probably
taken indirectly form MSDN as well.


The MSDN TOS reads:
> If Microsoft makes any code marked as “sample” available on this
> Web Site without a License Agreement, then that code is licensed
> to you under the terms of the Microsoft Limited Public License.

Where the MLPL can be found at:
<http://msdn.microsoft.com/en-us/cc300389.aspx#MLPL>.  It seems like
a perfectly legal free software license except point 3(F):

> (F) Platform Limitation- The licenses granted in sections 2(A) & 2(B)
> extend only to the software or derivative works that you create that
> run on a Microsoft Windows operating system product.

Also, 3(D) requires that the whole license is included:
> (D) If you distribute any portion of the software in source code form,
> you may do so only under this license by including a complete copy of
> this license with your distribution. If you distribute any portion of
> the software in compiled or object code form, you may only do so under
> a license that complies with this license.

Therefore, shall we include the license along with the INFs and ignore
the fact it's not fully free software?

_______________________________________________________________________
[1] I'm deliberately not using the word "lawyer" here not I give the
     person's name as to not make an impression that it was a legal
     advice or to make him in any way liable.  This was *not* a legal
     advice.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
