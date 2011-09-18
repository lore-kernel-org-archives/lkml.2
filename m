Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1IRIrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 04:47:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41850 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab1IRIrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 04:47:03 -0400
MIME-Version: 1.0
In-Reply-To: <1316333042.5814.23.camel@localhost.localdomain>
References: <1316333042.5814.23.camel@localhost.localdomain>
Date: Sun, 18 Sep 2011 10:47:01 +0200
X-Google-Sender-Auth: TPjOo0TrIYDYy3bEGmOP3R9MX78
Message-ID: <CAMuHMdVoVt3uYjExQfkd8LK3sjwA9ug=dQJ-w4cQ=QORKW93NA@mail.gmail.com>
Subject: Re: [PATCH 1/3] sys_poll: Fix negative timeout values for x86
 userland on x86_64 kernels v2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 10:04, Thomas Meyer <thomas@m3y3r.de> wrote:
> size of int and long differs on x86 and x86_64. the ia32 emulation calls

The size of int is the same on x86 and x86_64.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
