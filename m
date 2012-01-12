Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2ALGmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:42:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38915 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2ALGl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:41:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWnoKowa0atP0k5X4vukJTnQSNSh9gibxd1Y2e60qK3RQ@mail.gmail.com>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
 <CA+55aFw15sw0PWtom88vJx1M45CLuvpZABQAxMOQ+xowz8Xq2A@mail.gmail.com>
 <7vty438575.fsf@alter.siamese.dyndns.org> <201201111812.46431.arnd@arndb.de>
 <CAMuHMdVvQzdxw0B3ZMtJej=9Qwm7Qbd5aenSOfa=QPhX8UUt2w@mail.gmail.com>
 <CA+55aFxDdCUd_h2Xk3H3giO4GsAE05Y8-uN1tqRNOJiKV-mhGg@mail.gmail.com> <CAMuHMdWnoKowa0atP0k5X4vukJTnQSNSh9gibxd1Y2e60qK3RQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 22:41:36 -0800
X-Google-Sender-Auth: su1SX9P57QKCozH50zpyOFoWDzk
Message-ID: <CA+55aFxY5JGEGgeR8S8JKR_xC75g8MYOiVvGfisQGxf5oXD+7Q@mail.gmail.com>
Subject: Re: [GIT PULL 05/11] SoC-level changes for tegra and omap
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Junio C Hamano <gitster@pobox.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 10:32 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> That's why you need two branches:
>  1. a non-rebasing one for development,
>  2. a rebasing one containing cherry-picked (possibly folded) commits for
>     preparing for upstream delivery.

Stop being a moron.

Go back and read the "nobody can work with you". If you rebase for
upstream delivery, then that means that everybody that works with you
are workign with a tree that isn't ready for delivery, and that they
cannot rely on.

Just don't do it. If your tree is so ugly that you can't deliver it
upstream, then don't deliver it sideways or downstream either. Keep it
in your own pants, and don't make it public at all. Since nobody can
trust it anyway, and since it isn't the final end result, why even
bother? They can't rely on it, they can't work with it.

So here's the *real* solution:

 - make sure your development tree is in good enough shape that you
can make it public, and can ask me to pull it.

It really is that simple. If you don't think it's in good enough
shape, don't make it public.

                Linus
