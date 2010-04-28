Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0D1LyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:54:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53601 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0D1LyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:54:02 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 28 Apr 2010 13:54:17 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: USB gadget with drivers "on board"
In-reply-to: <4BD81ED5.1050408@draisberghof.de>
To: digidietze@draisberghof.de
Cc: Alan Stern <stern@rowland.harvard.edu>, Daniel Mack <daniel@caiaq.de>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vbvfcrps7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <Pine.LNX.4.44L0.1004261531480.1764-100000@iolanthe.rowland.org>
 <4BD5F43E.4090404@draisberghof.de> <op.vbu6nahq7p4s8u@pikus>
 <4BD81ED5.1050408@draisberghof.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Michał Nazarewicz schrieb:
>> Also, I think that it might be a good idea to make some "standardised"
>> mechanism for all such devices so that a generic udev code could be
>> written.  Adding things to the descriptors may be difficult in a way,
>> but maybe adding "[NoCD]" to the interface name would be enough.

On Wed, 28 Apr 2010 13:41:09 +0200, Josua Dietze <digidietze@draisberghof.de> wrote:
> That is up to the (countless) manufacturers of course; on the
> other hand, the Windows drivers need to recognize the mode as
> well so there should always be one way or the other to
> accomplish that.

Windows most likely recognises the device by vendor and product ID after the
drivers are installed.  On Linux you add a rule to udev (if I understand
correctly) which is a bit of a burden because (i) it takes time and (ii) the
list must be updated.  What I'm thinking is creating a generic way of marking
"install mode" devices so that no such list is necessary.  Of course, it'll
take time for vendors to recognise this scheme but maybe over time some major
players will.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
