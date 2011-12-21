Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1LUH7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:59:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42081 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1LUH7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:59:17 -0500
MIME-Version: 1.0
Date: Wed, 21 Dec 2011 08:59:03 +0100
X-Google-Sender-Auth: h8SSgaj6TUw5PGAOglwEBmIdWdk
Message-ID: <CAMuHMdUvnTWvaTndObFjA_pJXNWVpDBqxviyDpYvihc7pDiV3Q@mail.gmail.com>
Subject: sparc: __mcount_loc already exists (was: Re: Build
 regressions/improvements in v3.2-rc6)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 08:51, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Note that I deleted 5238 lines about "__mcount_loc already exists", to avoid
> my email being rejected.

I anyone planning to fix this? It only happens for sparc64/sparc-allmodconfig,
and appeared in v3.2-rc3.

linus: http://kisskb.ellerman.id.au/kisskb/buildresult/5167232/
linux-next: http://kisskb.ellerman.id.au/kisskb/buildresult/5166753/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
