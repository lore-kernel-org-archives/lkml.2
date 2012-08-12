Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2HLOKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 10:10:07 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64696 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2HLOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 10:10:04 -0400
MIME-Version: 1.0
In-Reply-To: <5027B6B2.70204@internode.on.net>
References: <5027B6B2.70204@internode.on.net>
Date: Sun, 12 Aug 2012 16:10:03 +0200
Message-ID: <CAFLxGvw5G6iC76nSaAg=bfnRqvdA-g4nxd+0qd-M_0SAQ9DKrQ@mail.gmail.com>
Subject: Re: fuse: implement i_op->atomic_open() prevents writes to ntfs-3g filesystem
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 3:59 PM, Arthur Marsh
<arthur.marsh@internode.on.net> wrote:
> [repost, apologies if you see it twice]
> I'm running Debian unstable on AMD64 (quad core) with Linus' github.com
> kernels.
>
> Recently (post 3.5.0 kernels) writes to an ntfs-3g filesystem started
> failing, and I bisected back to the following:
>
> # git bisect good
> c8ccbe032feb127a977c66865cb63d72d9a6e08b is the first bad commit
> commit c8ccbe032feb127a977c66865cb63d72d9a6e08b
> Author: Miklos Szeredi <mszeredi@suse.cz>
> Date:   Tue Jun 5 15:10:22 2012 +0200
>
>     fuse: implement i_op->atomic_open()
>
>     Add an ->atomic_open implementation which replaces the atomic
> open+create
>     operation implemented via ->create.  No functionality is changed.
>
>     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>
> :040000 040000 7a000897ad0d1524a7e1cb187bc77d92b8397d56
> 38f02e55f70b009f8b1149cdd75f571c72406fe4 M      fs
>
> Has this problem been seen by anyone else?
>
> Is a fix already in the works?

Adding some CCs.

-- 
Thanks,
//richard
