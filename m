Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1AZUGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:06:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40241 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab1AZUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BJSuUNqmaoT1fde8GuoVtNL7L8OXxSSremqNQDMG251FkjM3aFqSfcml7dBvPKx0Vq
         4AZUm5QpaBhj1tS8qX8+lnyEanlrsuuyS6YSZnvoszsvK07bNr43yGAqR0SB0mC0+ipM
         ZapACGacv0+Gjy/0dfePbX/nmKbTohQxj0fXs=
MIME-Version: 1.0
In-Reply-To: <76a04784-ace0-4be7-9dd7-a16e91803dc8@i25g2000prd.googlegroups.com>
References: <76a04784-ace0-4be7-9dd7-a16e91803dc8@i25g2000prd.googlegroups.com>
Date: Wed, 26 Jan 2011 12:05:49 -0800
Message-ID: <AANLkTimgOUS0syw2VF=t8PbLi5Xa5CBX6zzMhJFx_CCZ@mail.gmail.com>
Subject: Re: [tup] Tup with Linux kernel modules
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: tup-users@googlegroups.com
Cc: "marekfridrich@yahoo.com" <marekfridrich@yahoo.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 11:59 AM, mcgrof <mcgrof@gmail.com> wrote:
> Just curious if anyone has used tup to build the Linux kernel.
>
> http://gittup.org/tup/make_vs_tup.html

Check gittup http://gittup.org/gittup/

This is a Gentoo-like distributive that uses Tup tool. The distro
includes kernel/gcc/glib/zlib/binutils/ncurses/openssh/openssl/mplayer/...
and some other projects.

> Looks sexy.

And it is *very* fast for incremental builds. Just a short snippet
from the gittup page:

[marf@captainfalcon gittup]$ vi nethack/src/spell.c
[marf@captainfalcon gittup]$ vi busybox/coreutils/ls.c
[marf@captainfalcon gittup]$ time tup upd -j2
Executing Commands
[    0/9    ] busybox/coreutils/CC ls.c
[    1/9    ] nethack/CC src/spell.c
[    2/9    ] busybox/coreutils/LD built-in.o
[    3/9    ] busybox/LD busybox
[    4/9    ] nethack/LD nethack
[    5/9    ] initrd/bin/CP busybox
[    6/9    ] initrd/bin/CP nethack
[    7/9    ] initrd/MKINITRD
[    8/9    ] initrd/GZIP initrd
[    9/9    ]

real    0m1.571s
user    0m1.888s
sys     0m0.269s

Rebuilding whole system in 1.5 sec, isn't it cool?
