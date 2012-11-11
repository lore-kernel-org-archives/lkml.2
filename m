Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2KKJfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 04:35:44 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49952 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2KKJfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 04:35:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLpM_qvP65rXgjC-UV7Hc=-Lg17jtv0=dVUGHYJ_jB+tQ@mail.gmail.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-15-git-send-email-keescook@chromium.org>
	<CAMuHMdUXKc03UrNiUaTmxeynAy1oDBDgVbjjDKcJor4vM+0P3w@mail.gmail.com>
	<CAGXu5jLpM_qvP65rXgjC-UV7Hc=-Lg17jtv0=dVUGHYJ_jB+tQ@mail.gmail.com>
Date: Sun, 11 Nov 2012 10:35:42 +0100
X-Google-Sender-Auth: 4GjXIl5z5GmtVbEt4FtnlogjZ8o
Message-ID: <CAMuHMdVkSZh+mRPz73z9UnLw2AZwipatn5nBJyG13QBd_4fQ6g@mail.gmail.com>
Subject: Re: [PATCH 014/193] arch/m68k: remove CONFIG_EXPERIMENTAL
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Sun, Oct 28, 2012 at 4:41 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sun, Oct 28, 2012 at 2:18 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Tue, Oct 23, 2012 at 10:01 PM, Kees Cook <keescook@chromium.org> wrote:
>>> This config item has not carried much meaning for a while now and is
>>> almost always enabled by default. As agreed during the Linux kernel
>>> summit, remove it.
>>>
>>> CC: Geert Uytterhoeven <geert@linux-m68k.org>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>
>> Or do you want me to take this through the m68k tree?
>
> Stephen Rothwell has mentioned he'd prefer maintainers take these
> patches into their trees, but I'm happy to carry them in mine if you
> want to avoid the hassle. I'm doing this for several areas already.
> It's up to you, but just let me know so I can either drop it from my
> tree or move it to my linux-next tree. :)

OK, will queue for 3.8.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
