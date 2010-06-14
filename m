Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0FNUDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:03:53 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55489 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0FNUDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:03:52 -0400
Date: Mon, 14 Jun 2010 22:04:41 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv4.1 07/13] USB: gadget: g_ether: updated INF file
In-reply-to: <126481.74374.qm@web180312.mail.gq1.yahoo.com>
To: Xiaofan Chen <xiaofanc@gmail.com>, David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Message-id: <op.vea3d3ld7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <126481.74374.qm@web180312.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 21:42:46 +0200, David Brownell <david-b@pacbell.net> wrote:

> The updated copyright note
> Looks OK to me ...  (Though it seems wrong to
> reference so many folk yet omit the original
> author (me)

Uh... I basically took what Xiaofan provided and changed IDs and that's why.
But true enough, as I think about it now, I took some parts from the original
linux.inf file so there's probably *at* *least* as much your work as mine in
there.

I'll add you in the next version.  Or should I remove the notices all
together? Personally I feel they serve two purposes: give credit and let
others know who might be a good person to ask question.  I'm fine either
way...

> However, I don't see a version
> of the patch with the cleaner copyright notice.
>
> Also, please don't rename the file without
> updating all the references to the original
> name.  Since thoses refs are in docs all over
> the web ... I think it's best to just
> not rename it.

Ah, haven't thought about that.  I grepped Documentation/ but forgot
about grepping my personal copy of the Internet I keep in my basement. ;)

I intended a consistent naming and that's why the rename.  In any way,
I'll get the old name in the next version of the patch.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
