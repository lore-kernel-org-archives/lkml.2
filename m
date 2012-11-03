Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2KCOQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 10:16:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34211 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2KCOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:16:45 -0400
Message-ID: <50952744.4090203@gmail.com>
Date: Sat, 03 Nov 2012 15:16:36 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christof Meerwald <cmeerw@cmeerw.org>
CC: "Artem S. Tashkinov" <t.artem@lycos.com>, pavel@ucw.cz,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting
 a particular website
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05> <20121020162759.GA12551@liondog.tnic> <966148591.30347.1350754909449.JavaMail.mail@webmail08> <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic> <1781795634.31179.1350774917965.JavaMail.mail@webmail04> <20121103141049.GA24238@edge.cmeerw.net>
In-Reply-To: <20121103141049.GA24238@edge.cmeerw.net>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.11.2012 15:10, Christof Meerwald wrote:
> On Sat, 20 Oct 2012 23:15:17 +0000 (GMT), Artem S. Tashkinov wrote:
>> It's almost definitely either a USB driver bug or video4linux driver bug:
>>
>> I'm CC'ing linux-media and linux-usb mailing lists, the problem is described here:
>> https://lkml.org/lkml/2012/10/20/35
>> https://lkml.org/lkml/2012/10/20/148
> 
> Not sure if it's related, but I am seeing a kernel freeze with a
> usb-audio headset (connected via an external USB hub) on Linux 3.5.0
> (Ubuntu 12.10) - see

Does Ubuntu 12.10 really ship with 3.5.0? Not any more recent

> http://comments.gmane.org/gmane.comp.voip.twinkle/3052 and
> http://pastebin.com/aHGe1S1X for a self-contained C test.

Some questions:

 - Are you seeing the same issue with 3.6.x?
 - If you can reproduce this issue, could you paste the messages in
dmesg when this happens? Do they resemble to the list corruption that
was reported?
 - Do you see the same problem with 3.4?
 - Are you able to apply the patch Alan Stern posted in this thread earlier?

We should really sort this out, but I unfortunately lack a system or
setup that shows the bug.


Thanks,
Daniel

