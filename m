Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab2KFROs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 12:14:48 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62768 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2KFROr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 12:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
Date: Tue, 6 Nov 2012 18:14:45 +0100
X-Google-Sender-Auth: u3X6_9pNrZ9PiBL7Ah_7jKPUq9k
Message-ID: <CAMuHMdW7esRw94DzcQ4=UeXjeY7ETAUmRvXnP4M6YYCz2UbNOg@mail.gmail.com>
Subject: Re: [PATCH v2 000/104] remove CONFIG_EXPERIMENTAL
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 12:03 AM, Kees Cook <keescook@chromium.org> wrote:
> For items that really are experimental, maintainers should use "default
>   n", optionally include "(EXPERIMENTAL)" in the title, and add language to
>   the help text indicating why the item should be considered experimental.

"default n" is the default. Unless you have a very good reason, you should never
have "default y".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
