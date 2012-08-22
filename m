Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab2HVRSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:18:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46039 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab2HVRSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
Date: Wed, 22 Aug 2012 19:18:04 +0200
X-Google-Sender-Auth: 2Xj0lGsK2S1hP6ZttYsBsmfYvJo
Message-ID: <CAMuHMdUt62GsYsPMAPbUWZUtFL=c2VmYFintpDAQmSwQrWriuA@mail.gmail.com>
Subject: Re: [PATCH 00/10] rcu: Add missing RCU idle APIs on idle loop
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Chris Zankel <chris@zankel.net>, "3.2.x.." <stable@kernel.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 6:23 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> So this fixes some potential RCU stalls in a bunch of architectures.
> When rcu_idle_enter()/rcu_idle_exit() became a requirement, we forgot
> to handle the architectures that don't support CONFIG_NO_HZ.
>
> I guess the set should be dispatched into arch maintainer trees.

I can take the m68k version, but are you sure you want it this way?
Each of them must be in mainline before they can enter stable.

> I'm sorry I haven't built tested everywhere. But the changes are
> small and need to be at least boot tested anyway.

Builds and boots fine on m68k under ARAnyM.
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> (for m68k)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
