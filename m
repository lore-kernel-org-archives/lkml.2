Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab1KCH3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:29:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49500 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1KCH3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:29:08 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au>
References: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au>
Date: Thu, 3 Nov 2011 08:29:06 +0100
Message-ID: <CA+icZUX1juRU51gXFrX7ZeKgtV9=0bmFKLYZCcuyTfW5E1SL+A@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 3
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Christoph Hellwig <hch@lst.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 7:20 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> The linux-next tree on github is no longer being updated and will be
> removed soon.
>
> The patch is still absent from kernel.org.
>
> The summary at the end now has a "git -1 --oneline" appended to the lines
> indicating which tree is being merged.   This was suggested by Mauro
> Chehab as an aid to maintainers so that they can easily tell which version
> of their tree was merged.  Comments welcome.
>
> Changes since 20111102:
>
> Renamed trees:
>        wireless -> wireless-next
>        wireless-current -> wireless
>

Whuzzz up with VFS tree(s)?

[1] and [2] lists:
vfs             git
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git#for-next
vfs-scale       git
git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git#vfs-scale-working

Isn't vfs-scale [2] done?
I have so long not heard or read from Nick Piggin (vfs-scale), I hope
he is well.

Christoph take over as interim VFS stuff from Al (hope he is well,
too) and I have seen his and pending stuff from FS folk was merged
into Linus-tree.
Christoph, your for-next GIT branch [3] is dedicated for linux-next (v3.3)?

- Sedat -

[1] http://git.us.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/Trees#l89
[2] http://git.us.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/Trees#l90
[3] http://git.kernel.org/?p=linux/kernel/git/hch/vfs-queue.git;a=shortlog;h=refs/heads/for-next
