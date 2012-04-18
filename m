Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab2DRHqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:46:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58079 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2DRHqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:46:22 -0400
MIME-Version: 1.0
In-Reply-To: <1334695036-19977-4-git-send-email-richard@nod.at>
References: <1334695036-19977-1-git-send-email-richard@nod.at>
	<1334695036-19977-4-git-send-email-richard@nod.at>
Date: Wed, 18 Apr 2012 09:46:21 +0200
X-Google-Sender-Auth: FJJV1mfBauKTrZgd4IFReB4lHnc
Message-ID: <CAMuHMdXXGSyQN0U_KntTn3ydeZ7tAqJh2445ptvo+GYwV_SNMg@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 4/4] irq: Remove irq_chip->release()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 22:37, Richard Weinberger <richard@nod.at> wrote:
> As it's only user (UML) does no longer need it we can get
> rid of it.

But now all drivers have to call um_free_irq() instead of free_irq()?
Are there any generic drivers not specific to UML we do want to use on UML?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
