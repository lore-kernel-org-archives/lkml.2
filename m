Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab2KPHCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:02:42 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35865 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2KPHCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:02:40 -0500
MIME-Version: 1.0
In-Reply-To: <1353046873.24310.30.camel@joe-AO722>
References: <20121030211530.09F1320004E@hpza10.eem.corp.google.com>
	<1353046873.24310.30.camel@joe-AO722>
Date: Fri, 16 Nov 2012 08:02:39 +0100
X-Google-Sender-Auth: fpZg5SEZlJUdLyweYgq30Q-mmvI
Message-ID: <CAMuHMdVxZqQLK4cKD7oYj31c-=LoBsaaoTQTqJcHg-nzg2iG_w@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: extend line continuation test
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>, Andy Whitcroft <apw@canonical.com>,
        peter@hurleysoftware.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 7:21 AM, Joe Perches <joe@perches.com> wrote:
> Preprocessor directives and asm statements should be
> allowed to have a line continuation.

For preprocessor directives I agree.

But why do asm statements need it? They'r just strings, so just closing with
a double quote at the end of the first line, and opening again with a
double quote
on the next line works fine.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
