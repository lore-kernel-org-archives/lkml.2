Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0DSJEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:04:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65089 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0DSJEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:04:11 -0400
Date: Mon, 19 Apr 2010 11:04:19 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 3/8] USB: gadget: __init and __exit tags removed
In-reply-to: <w2v8bd0f97a1004190102pd928e442td837c8fcee0541c5@mail.gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vbejhhcz7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1271406290.git.mina86@mina86.com>
 <0d8cfc5167bbcbfc6c5ae0ab10980eba743e0cee.1271406290.git.mina86@mina86.com>
 <7fbfe9c15eae523b73b704a3b5399319152fd505.1271406290.git.mina86@mina86.com>
 <41b2cd7e8bacd38bb9c997b7197e175d727876f9.1271406290.git.mina86@mina86.com>
 <n2v8bd0f97a1004161640q640bade7xd4887dde5921b79e@mail.gmail.com>
 <op.vbegell27p4s8u@pikus>
 <w2v8bd0f97a1004190102pd928e442td837c8fcee0541c5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2010/4/19 Michał Nazarewicz:
>> Yes, I agree.  That's why in the first version I proposed the
>> __usb_init, __usb_exit, etc. tags which could be customized
>> prior to including composite related files.

Mike Frysinger:
> seems like __usbgadget_xxx would be better naming, but i'm not
> interested in fighting to get the idea in general accepted

Bit long though, but yes makes more sense.

>> What's more, I don't see any other (that is cleaner) solution which
>> would allow flexibility so it seems what we can either choose
>> a non-flexible solution proposed by this patch or an ugly solution
>> proposed by my previous patch.

> i dont have a problem with your current patch (since there are still
> seciton mismatch warnings floating about that i imagine this is going
> to fix), just with the general situation

Yes, I understand that.  I'm just clarifying the situation we are in
so maybe someone will came up with some better solution then the ones
already proposed.

-- 
Best regards,                                           _     _
   .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
   ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
   ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
