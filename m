Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab0DNMuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:50:40 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23480 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0DNMui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:50:38 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 14 Apr 2010 14:50:41 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 7/8] USB: testusb: imported David Brownell's USB testing
 application
In-reply-to: <201004140241.47445.david-b@pacbell.net>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.va5kmrtr7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1270644740.git.mina86@mina86.com>
 <15d6fb76583235c380569d11d904cc0e8d019067.1270644740.git.mina86@mina86.com>
 <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com>
 <201004140241.47445.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 07 April 2010, Michal Nazarewicz wrote:
>> The testusb application can be used to test various USB gadget
>> that implment the source/sink intrerface.

On Wed, 14 Apr 2010 11:41:47 +0200, David Brownell <david-b@pacbell.net> wrote:
> That comment is woefully incomplete.  It's not just gadgets it
> exercises, and a lot of thought went into testing streaming modes
> too (within limitations of a the trivial test harness).
>
> It's part of a fairly complete test suite which exercises:
> - all four types of USB 2.0 data transfer, on both peripheral
>   and host sides,
> - good coverage of observed hardware and software failure modes,
> - decent coverage of Linux-USB programming interfaces, and
> - stress test modes
>
> For more info, which *SHOULD* be referenced from wherever the
> kernel tree includes any of this code:
>
> See: http://www.linux-usb.org/usbtest/
>
> Just throwing tools at someone without instructions can be rather
> counter-productive .... they get misused, important issues ignored,
> results mis-interpreteed, etc.
>
> Note that there's a basic test plan, letting folk put drivers
> (and hardware) through their paces.  The evidence is that when
> drivers behave on that whole suite, Linux won't misbehave much
> at all.
>
> In fact, without such tools and a test plan, it'd be hard to have
> much faith in the driver quality...  except as a weak and scattershot
> "this combination of drivers and hardware seems OK for now".  futile
>
> At one point there were allegedly folk working on Linux testing
> frameworks, but they never seem to have looked at this (even on
> specific request); I'm not sure if it was just general weakness
> in driver testing efforts (they're not easy to test), lack of
> background (/interest?) in USB, or something else.


Let me start with explaining that my original intent was not to get the
testing code to the Linux kernel and thus I limited documentation to
minimum.  I just wanted to put some code that may be used to test the
FunctionFS out into the air so that anyone who stumbles across the
patchset can test the FunctionFS code even though the test code may be
not inside the mainline kernel.

However, if Greg thinks it might be a good idea to put some testing code
into the tree, then it's fine by me.  This may even lead to more testing
tools be submitted and maybe after some time an unified testing framework
may emerge.

Bottom line is, if community (represented by the maintainer ;) ) wants the
patches in the kernel, then let them have it!


Obviously, the higher the quality patches are the better, so all the constructive
criticism is welcomed.  Thus I accept your comments and agree with them.  What
I'd like to ask though is what you are proposing?

Should I put a short comment saying this file is part of a greater test suite
with a link to the linux-usb.org/usbtest site?  Or maybe more code and/or
documentation should be included in the kernel?  Or maybe the whole idea of
including this code in the kernel was not so good?

I'm happy either way so I'd like to do what's the best for Linux and community
thus am asking for your comments (and I mean "your" as in plural :) ).


> On Wednesday 07 April 2010, Greg KH wrote:
>> You should put a:
>>         From: David Brownell <dbrownell@users.sourceforge.net>
>> as the first line of the body of this patch, so it properly shows up as
>> David's code.

On Wed, 14 Apr 2010 11:30:52 +0200, David Brownell <david-b@pacbell.net> wrote:
> ISTR sending an ack .... but, not with a "From:" like that.  I did author the
> code, but the *patch* is not from me.

Do you think a commit with me as an author and a clear indication in the
message that it imports your code would be better?

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
