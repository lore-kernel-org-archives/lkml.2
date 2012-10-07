Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2JGGgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 02:36:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35014 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2JGGgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 02:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <22758.1349565339@warthog.procyon.org.uk>
References: <22758.1349565339@warthog.procyon.org.uk>
Date: Sun, 7 Oct 2012 08:36:20 +0200
X-Google-Sender-Auth: wcTzIy_rNefFnfiwewL8omqSJkQ
Message-ID: <CAMuHMdX2TgSbTj8yjyRKXT=RJ0E+efR7FH-vzoWL8+-SCUN29w@mail.gmail.com>
Subject: Re:
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, arnd@arndb.de, hpa@zytor.com, catalin.marinas@arm.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, ddaney.cavm@gmail.com,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 1:15 AM, David Howells <dhowells@redhat.com> wrote:
>  (3) m68k turned out to have a header installation problem due to it lacking a
>      kvm_para.h file.

Sh also.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
