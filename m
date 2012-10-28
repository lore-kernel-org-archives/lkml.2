Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab2J1JSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 05:18:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44080 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2J1JSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 05:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <1351022666-6960-15-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-15-git-send-email-keescook@chromium.org>
Date: Sun, 28 Oct 2012 10:18:40 +0100
X-Google-Sender-Auth: r2JdEE4bk5Ljkgrgp091ZNuhuug
Message-ID: <CAMuHMdUXKc03UrNiUaTmxeynAy1oDBDgVbjjDKcJor4vM+0P3w@mail.gmail.com>
Subject: Re: [PATCH 014/193] arch/m68k: remove CONFIG_EXPERIMENTAL
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:01 PM, Kees Cook <keescook@chromium.org> wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Or do you want me to take this through the m68k tree?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
