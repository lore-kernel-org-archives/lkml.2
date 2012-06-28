Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2F1Sqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 14:46:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43221 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2F1Sqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 14:46:53 -0400
MIME-Version: 1.0
In-Reply-To: <1340361221.1773.78.camel@x61.thuisdomein>
References: <1340361221.1773.78.camel@x61.thuisdomein>
Date: Thu, 28 Jun 2012 20:46:52 +0200
X-Google-Sender-Auth: 4WKOaozYK6zgUjVsOHUYo7BURA0
Message-ID: <CAMuHMdXjnAbNAjB=0jG1jRt5vWewYG+6Ky9oi01n96ngAUB=dw@mail.gmail.com>
Subject: Re: [PATCH] m68k: remove never used asm/shm.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 12:33 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> m68k's asm/shm.h header has been part of the tree ever since m68k
> support got added in v1.3.94. (It started as /include/asm-m68k/shm.h and
> moved to its current location a few years ago.) It seems it was never
> used: no file ever included it and nothing used the macros it defines.
>
> (Actually, from v2.5.46 until v2.6.29-rc3 it was included by m68knommu's
> asm/shm.h. But that header was just a very thin wrapper for this header
> and was itself unused too.)
>
> This header can safely be removed.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thx, queued for 3.6.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
