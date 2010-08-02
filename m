Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0HBMps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:45:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50121 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0HBMpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:45:47 -0400
Date: Mon, 02 Aug 2010 14:47:16 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv5 1/3] USB: gadget: composite: Better string override
 handling
In-reply-to: <28603.82914.qm@web180301.mail.gq1.yahoo.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vgs9s2f17p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <28603.82914.qm@web180301.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 13:26:05 +0200, David Brownell <david-b@pacbell.net> wrote:

>>> NAK.  You're still hard-wiring an un-managed
>>> serial number.

>> Uh?  I'm not.

> Are too.  There's a line assigning such an
> un-managed number.  Get rid of it instead of
> denying its existence (and then justifying it).

Could you point that line to me, please?  I fail to see it in this
patch...  And it wasn't my intention to allow unmanaged serial number
with this patch, so if there is such code then I must have missed it
somehow.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
