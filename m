Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab2LPCGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 21:06:18 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53195 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2LPCGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 21:06:17 -0500
MIME-Version: 1.0
In-Reply-To: <20121216015300.GA4939@ZenIV.linux.org.uk>
References: <CAAJw_ZueeeNwCGnQD75=AcNwLxWBM3hEvq3LYXEiMcz4Sibk-w@mail.gmail.com>
	<20121216012816.GZ4939@ZenIV.linux.org.uk>
	<CAAJw_ZsM+nWJc8nu7GiXrbOMftwwVvyYDczO6yBuCEGyoCrT8g@mail.gmail.com>
	<20121216015300.GA4939@ZenIV.linux.org.uk>
Date: Sun, 16 Dec 2012 10:06:16 +0800
Message-ID: <CAAJw_Zun1Ax1jf4C8wyfvHQHCo5gE869bjD3Ck1cRWuDkPr7bw@mail.gmail.com>
Subject: Re: /usr/include/linux/errno.h:1:23: fatal error: asm/errno.h: No
 such file or directory
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 9:53 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Dec 16, 2012 at 09:39:01AM +0800, Jeff Chua wrote:
>> On Sun, Dec 16, 2012 at 9:28 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Sun, Dec 16, 2012 at 09:23:38AM +0800, Jeff Chua wrote:
>> >> How should the symbolic links be setup to compile the latest kernel?
>> >>
>> >>
>> >> Currently I had these links and kernels compiled fine until 2 days ago.
>> >>
>> >>          asm -> /usr/src/linux/include/uapi/asm-generic/
>> >>          asm-generic -> /usr/src/linux/include/uapi/asm-generic
>> >>          linux -> /usr/src/linux/include/uapi/linux
>> >
>> > What symlinks?  /usr/include/* should not contain any symlinks into
>> > the kernel source.  At all.
>>
>> Al,
>>
>> Oh, perhaps I'm having the right setup. Where should I get the kernel
>> headers.
>
> From your libc.  Which ought to have its own copies, normally coming from
> make headers_install in kernel source.  And yes, it had been that way
> for many years by now.  Userland should *not* blindly grab the kernel
> headers.
>
> Incidentally, your 'asm' is obviously bogus - the headers that should end
> up there ought to come from arch/<whatever>/include/uapi/asm (and _not_
> by pointing a symlink to it); yours points to the place where asm-generic
> ones ought to have been copied from.

Al,

Thanks for the pointers. Will try as what you suggested:)

Merry Christmas.

Jeff
