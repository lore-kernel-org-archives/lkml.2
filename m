Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1DSJFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:05:24 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:54976 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1DSJFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:05:23 -0400
Message-ID: <4DAD5046.3030008@ahsoftware.de>
Date: Tue, 19 Apr 2011 11:05:10 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Implement /dev/byte (a generic byte source similiar
 to /dev/zero)
References: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>	<BANLkTi=yaXOWnUi2s1A-BtoAFgjExX8q4w@mail.gmail.com>	<4DAD48FC.5040003@ahsoftware.de> <20110419094436.0b667410@lxorguk.ukuu.org.uk>
In-Reply-To: <20110419094436.0b667410@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 19.04.2011 10:44, schrieb Alan Cox:
>> As for /dev/zero there are many other possible reasons to use such a
>> device, besides filling something with a value. For me it's as
>> reasonable as dev/zero, just that it offers a bit more flexibility and
>> provides another, at least for me useful, default value. Maybe
>> /dev/nzero would have been a good name too. ;)
>
> /dev/zero exists not to put \0's into files as such but because it is
> very useful to be able to map the zero page (a read only, or
> copy-on-write blank page) into programs. The mmap is the reason it is
> there.

Thanks for the explanation.

>> But I don't really care about inclusion into the kernel, it's just
>> something I had lying around (and needed only marginally work to
>> finalize as a proper patch) and I thought someone else could find it
>> usefull and I should share that here.
>
> Implementationwise I think I would have gone for allocating a new device
> and range of 256 minors - that would avoid the funky stuff setting what
> it fills with as you'd just fill with the minor number.

I thought about that too, but that would have been to easy (and static). ;)

And the usage of file descriptors was the only idea I've come up with, 
which is multitasking and multiuser aware.

Regards,

Alexander
