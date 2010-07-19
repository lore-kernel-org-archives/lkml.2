Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270Ab0GSI5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 04:57:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50191 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247Ab0GSI45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 04:56:57 -0400
Date: Mon, 19 Jul 2010 10:58:14 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-reply-to: <536935.13464.qm@web180310.mail.gq1.yahoo.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Message-id: <op.vf21vchq7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <536935.13464.qm@web180310.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jul 2010 01:57:30 +0200, David Brownell <david-b@pacbell.net> wrote:
> Still no fan, since it just duplicates
> existing functionality from the composite
> framework.  Using  the existing mechanism
> seems preferable to me:  you want a serial
> number? provide one using the existing scheme
> and just make sure it follows the rules.

Hello David,

I'm still not sure what you mean.

As a matter of fact I think you might be confusing Mass Storage Gadget
with File Storage Gadget.

The first patch in the series merely adds the initialisation for the
iSerialNumber field of the descriptor of Mass Storage Gadget (which
is a composite gadget).  It in no way duplicates functionality of
the composite layer.  As a matter of fact, without this patch, the
iSerialNumber module parameter won't work (not tested, just looked
at the code).

The second patch (by Yann Cantin) adds a serial module parameter to
the File Storage Gadget.  FSG is not a composite gadget so the patch
does not duplicate composite functionality (well it does but it's
irrelevant since FSG cannot use composite anyway).

The third patch is irrelevant in this discussion I believe.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
