Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0FIPwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:52:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33990 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0FIPwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:52:23 -0400
Date: Wed, 09 Jun 2010 17:53:09 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv4 08/13] USB: gadget: g_serial: INF file updated
In-reply-to: <20100609153351.GB21431@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Xiaofan Chen <xiaofanc@gmail.com>, linux-usb@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vd1ievcz7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.53 (Linux)
References: <996015.66352.qm@web180311.mail.gq1.yahoo.com>
 <op.vd0y3ds37p4s8u@pikus>
 <AANLkTim6GHWVNvZ1XOJBZiu7ltl7TVpVJwVltLoKpYRi@mail.gmail.com>
 <op.vd014urd7p4s8u@pikus> <20100609145946.GB20543@kroah.com>
 <op.vd1g0kcc7p4s8u@pikus> <20100609153351.GB21431@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jun 2010 17:33:51 +0200, Greg KH <greg@kroah.com> wrote:
>> The RNDIS template was taken from:
>> http://msdn.microsoft.com/en-us/library/ff570620.aspx
>>
>> The CDC ACM was sent by Xiaofan Chen who said that it is probably
>> taken indirectly form MSDN as well.
>
> Ok, and not from the Windows DDK, right?  That has a different license
> than MSDN.

RNDIS is from MSDN for sure.  As of serial, I couldn't find it there.

>> The MSDN TOS reads:
>> >If Microsoft makes any code marked as “sample” available on this
>> >Web Site without a License Agreement, then that code is licensed
>> >to you under the terms of the Microsoft Limited Public License.
>>
>> Where the MLPL can be found at:
>> <http://msdn.microsoft.com/en-us/cc300389.aspx#MLPL>.  It seems like
>> a perfectly legal free software license except point 3(F):
>>
>> >(F) Platform Limitation- The licenses granted in sections 2(A) & 2(B)
>> >extend only to the software or derivative works that you create that
>> >run on a Microsoft Windows operating system product.
>>
>> Also, 3(D) requires that the whole license is included:
>> >(D) If you distribute any portion of the software in source code form,
>> >you may do so only under this license by including a complete copy of
>> >this license with your distribution. If you distribute any portion of
>> >the software in compiled or object code form, you may only do so under
>> >a license that complies with this license.
>>
>> Therefore, shall we include the license along with the INFs and ignore
>> the fact it's not fully free software?

> No, it's not "software" here, and it is abiding by the license of the
> MLPL as you don't run that file on any non-Windows machine.

Well...  According to the license (if we assume the license apply to the
INF template) it is "software":
> This license governs use of code marked as “sample” available on this
> Web Site without a License Agreement , as provided under the Section
> above titled “NOTICE SPECIFIC TO SOFTWARE AVAILABLE ON THIS WEB SITE”.
> If you use such code (the “software”), you accept this license.

On Wed, 09 Jun 2010 17:33:51 +0200, Greg KH <greg@kroah.com> wrote:
> How about putting the following on the file:
> 	; based on a example .inf file that was:
> 	;	Copyright (c) Microsoft Corporation
> 	; and released under the MLPL as found at
> 	; http://msdn.microsoft.com/en-us/cc300389.aspx#MLPL
> 	; For use only on Windows operating systems.
> 	;
>
> Interesting that they don't put a date on the copyright.
>
> With that wording, I'd be glad to take it.

If no one sees any legal issues here I can change the patch accordingly.
I'm more and more confused by the whole issue. ;)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
