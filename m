Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1GAHAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:00:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39276 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab1GAHAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <1309461732-2875-2-git-send-email-jonas@southpole.se>
References: <201106281245.19457.arnd@arndb.de>
	<1309461732-2875-1-git-send-email-jonas@southpole.se>
	<1309461732-2875-2-git-send-email-jonas@southpole.se>
Date: Fri, 1 Jul 2011 09:00:13 +0200
X-Google-Sender-Auth: XeTWzvLx21Igt7Ii8J50oI3xFeE
Message-ID: <BANLkTi=j+3eovYhcjoniFrCL_vAC0BQCdw@mail.gmail.com>
Subject: Re: [PATCH 2/2] modules: make arch's use default loader hooks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: rusty@rustcorp.com.au, arnd@ardnb.de, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 21:22, Jonas Bonn <jonas@southpole.se> wrote:
> This patch removes all the module loader hook implementations in the
> architecture specific code where the functionality is the same as that
> now provided by the recently added default hooks.
>
> Signed-off-by: Jonas Bonn <jonas@southpole.se>

>  arch/m68k/kernel/module_mm.c    |   27 -----------------
>  arch/m68k/kernel/module_no.c    |   34 ---------------------

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
