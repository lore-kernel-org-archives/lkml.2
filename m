Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2BSK2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 05:28:35 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34470 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2BSK2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 05:28:33 -0500
MIME-Version: 1.0
In-Reply-To: <1328677745-20121-12-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
	<1328677745-20121-12-git-send-email-hpa@zytor.com>
Date: Sun, 19 Feb 2012 11:28:31 +0100
X-Google-Sender-Auth: eoT_HGuAGxXlZp7kI3tr3iJSFec
Message-ID: <CAMuHMdU_+WcfKTp3rEWdjtkKt-JdE16TTZo0Et-znmGXtZQ8Eg@mail.gmail.com>
Subject: Re: [PATCH 11/21] m68k: Use generic posix_types.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 06:08, H. Peter Anvin <hpa@zytor.com> wrote:
> Change the m68k architecture to use <asm-generic/posix_types.h>.
>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>

Thx, looks OK, so
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
