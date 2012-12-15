Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2LOVL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 16:11:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45863 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2LOVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 16:11:25 -0500
MIME-Version: 1.0
In-Reply-To: <50CAFDFF.3070802@ti.com>
References: <50CAFDFF.3070802@ti.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Dec 2012 13:11:04 -0800
X-Google-Sender-Auth: jXHHKl9__G5Rw8mHvkmC5GYPW1c
Message-ID: <CA+55aFz9+3mOZcjJ9C-izKkidT9mxeO7xUubJER0OTjcZjE=2A@mail.gmail.com>
Subject: Re: [GIT PULL] fbdev changes for 3.8
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 2:22 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> Hi Linus,
>
> Florian, the fbdev maintainer, has been very busy lately, so I offered to send
> the pull request for fbdev for this merge window.

Pulled. However, with this I get the Kconfig question

   OMAP2+ Display Subsystem support (OMAP2_DSS) [N/m/y/?] (NEW)

which doesn't make a whole lot of sense on x86-64, unless there's
something about OMAP2 that I don't know.

So I'd suggest making that OMAP2_DSS be dependent on OMAP2. Or at
least ARM. Because showing it to anybody else seems insane.

Same goes for FB_OMAP2 for that matter. I realize that it's likely
nice to get compile testing for this on x86-64 too, but if that's the
intent, we need to think about it some more. I don't think it's good
to ask actual normal users questions like this just for compile
coverage.

Hmm?

                    Linus
