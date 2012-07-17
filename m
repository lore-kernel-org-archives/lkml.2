Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2GQUvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:51:22 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51745 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2GQUvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:51:19 -0400
MIME-Version: 1.0
In-Reply-To: <5005CB11.6000205@xenotime.net>
References: <20120717154153.b10774cb005add05e4c4e5f6@canb.auug.org.au>
	<5005CB11.6000205@xenotime.net>
Date: Tue, 17 Jul 2012 22:51:18 +0200
X-Google-Sender-Auth: 4lbyY749gWSaYPXvaUBAoKToKeA
Message-ID: <CAMuHMdUwPAx1BO=FAw7sCfa3wU7cwtn6T0hCdkWDGkP8D3T0YQ@mail.gmail.com>
Subject: Re: linux-next: Tree for July 17 (fs/sync.c)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 10:29 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 07/16/2012 10:41 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120716:
>>
>> The vfs tree lost its build failure.
>
>
>
> on i386:
>
> fs/sync.c: In function 'sys_sync':
> fs/sync.c:110:2: error: implicit declaration of function 'iterate_bdevs'
>
>
> Full randconfig file is attached.

According to https://lkml.org/lkml/2012/7/17/61, it happens for
!CONFIG_BLOCK

Also in e.g. sh-allnoconfig,
http://kisskb.ellerman.id.au/kisskb/buildresult/6722464/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
