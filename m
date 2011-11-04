Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1KDOiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:38:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57818 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1KDOiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:38:04 -0400
MIME-Version: 1.0
In-Reply-To: <4EB3F094.30307@lougher.demon.co.uk>
References: <4EB3F094.30307@lougher.demon.co.uk>
Date: Fri, 4 Nov 2011 23:38:02 +0900
Message-ID: <CAKYAXd87eNQqDs2Ks5pFkA8dxsb49Ub2UmmWfsQVC8n6F3sfKA@mail.gmail.com>
Subject: Re: [GIT PULL] Squashfs updates for 3.2
From: NamJae Jeon <linkinjeon@gmail.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/4 Phillip Lougher <phillip@lougher.demon.co.uk>:
> Hi Linus,
>
> Please consider pulling the following minor Squashfs update.
>
> Thanks
>
> Phillip
>
>
> The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:
>
>  Linux 3.1 (2011-10-24 09:10:05 +0200)
>
> are available in the git repository at:
>  git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git master
>
> Phillip Lougher (1):
>      Squashfs: Add an option to set dev block size to 4K
>
>  fs/squashfs/Kconfig       |   22 ++++++++++++++++++++++
>  fs/squashfs/squashfs_fs.h |    7 +++++++
>  fs/squashfs/super.c       |    2 +-
>  3 files changed, 30 insertions(+), 1 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Hi. Phillip.

I already posted this patch before ([PATCH] squashfs : devblksize set
to 4KB intead of BLOCK_SIZE(1KB).).
It is similar with my patch except option.
Have you ever seen this patch ? I didn't response about this patch from you.

Thanks.
