Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2LPBjE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 20:39:04 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39418 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2LPBjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 20:39:02 -0500
MIME-Version: 1.0
In-Reply-To: <20121216012816.GZ4939@ZenIV.linux.org.uk>
References: <CAAJw_ZueeeNwCGnQD75=AcNwLxWBM3hEvq3LYXEiMcz4Sibk-w@mail.gmail.com>
	<20121216012816.GZ4939@ZenIV.linux.org.uk>
Date: Sun, 16 Dec 2012 09:39:01 +0800
Message-ID: <CAAJw_ZsM+nWJc8nu7GiXrbOMftwwVvyYDczO6yBuCEGyoCrT8g@mail.gmail.com>
Subject: Re: /usr/include/linux/errno.h:1:23: fatal error: asm/errno.h: No
 such file or directory
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 9:28 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Dec 16, 2012 at 09:23:38AM +0800, Jeff Chua wrote:
>> How should the symbolic links be setup to compile the latest kernel?
>>
>>
>> Currently I had these links and kernels compiled fine until 2 days ago.
>>
>>          asm -> /usr/src/linux/include/uapi/asm-generic/
>>          asm-generic -> /usr/src/linux/include/uapi/asm-generic
>>          linux -> /usr/src/linux/include/uapi/linux
>
> What symlinks?  /usr/include/* should not contain any symlinks into
> the kernel source.  At all.

Al,

Oh, perhaps I'm having the right setup. Where should I get the kernel
headers. After removing the links to the kernel source, here what I
got ...

make[1]: Nothing to be done for `all'.
  HOSTCC  scripts/basic/fixdep
In file included from /usr/include/bits/posix1_lim.h:160:0,
                 from /usr/include/limits.h:144,
                 from scripts/basic/fixdep.c:114:
/usr/include/bits/local_lim.h:38:26: fatal error: linux/limits.h: No
such file or directory
compilation terminated.

Thanks,
Jeff.
