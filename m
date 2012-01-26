Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2AZRSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:18:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56949 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2AZRSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:18:30 -0500
MIME-Version: 1.0
In-Reply-To: <4F2052DB.4060602@xenotime.net>
References: <20120125141938.c1a9460d56948e1c7b26d3f8@canb.auug.org.au>
	<4F2052DB.4060602@xenotime.net>
Date: Thu, 26 Jan 2012 18:18:28 +0100
X-Google-Sender-Auth: miduRyICJJMKZgyeGAQFxaYAPtA
Message-ID: <CAMuHMdWp1wEHqPXNs+kaMYpomJnfbZPJjRk5GVFCuCL4Q5zK7g@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 25 (net/sock.h, jump_label, memcg)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 20:07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> back to net/sock.h and jump_label:
>
> (on i386:)
>
> /next/linux-next-20120125/include/net/sock.h:953:2: error: implicit declaration of function 'static_branch'
> /next/linux-next-20120125/include/linux/jump_label.h:43:29: error: conflicting types for 'static_branch'
>
> Full randconfig file is attached.

Without having to add randomness, also in m68k/allmodconfig, now in Linus'
tree :-(
http://kisskb.ellerman.id.au/kisskb/buildresult/5491860/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
