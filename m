Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0G1OAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:00:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52575 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0G1OAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:00:47 -0400
Date: Wed, 28 Jul 2010 16:02:14 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv5 3/3] USB: gadget: storage_common: fixed warning building
 mass storage function
In-reply-to: <AANLkTimavNK1cFhOndEBJrz0NWDn+GUYsLkBDEN9XFwr@mail.gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <op.vgj3x0pp7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <38424b23c94ddcff6f1808161912f362c2ccae39.1280316431.git.m.nazarewicz@samsung.com>
 <7b3ddf05e135e8147d1011a81f9069d9cd78aa62.1280316431.git.m.nazarewicz@samsung.com>
 <d7a11c97d1b28c7a0336c747de57a9a17dcc7604.1280316431.git.m.nazarewicz@samsung.com>
 <AANLkTikW8eSn3fgRqJsXwp=+ZMjKgojHDP6+DsDMtg4y@mail.gmail.com>
 <op.vgj05nev7p4s8u@pikus>
 <AANLkTimavNK1cFhOndEBJrz0NWDn+GUYsLkBDEN9XFwr@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 15:42:33 +0200, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> 2010/7/28 Michał Nazarewicz <m.nazarewicz@samsung.com>:
>>> Why the warning happens for those two only?
>>> There are two more parameters (four methods) to handle 'ro' and 'file'
>>> which are done in the same way.
>>
>> Those are the only ones that are not used by the mass storage function.
> Now I got it.
>
> I'm just wondering if it somehow useful to append similar parameter to
> that function.

I intend to add it later on when I'll have bit more time.  For now just
a quick fix and an entry in my TODO. ;)

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
