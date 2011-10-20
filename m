Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1JTGyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:54:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58697 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1JTGyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <4E9FB0D6.9080301@snapgear.com>
References: <1318925407.6414.22.camel@x61.thuisdomein>
	<4E9D6C05.9040106@snapgear.com>
	<1318941043.6414.35.camel@x61.thuisdomein>
	<4E9FB0D6.9080301@snapgear.com>
Date: Thu, 20 Oct 2011 08:54:05 +0200
X-Google-Sender-Auth: RAJ7a7DBZaCHOviAHPjR3vNX7B8
Message-ID: <CAMuHMdVpAhJDhTDSwRWb7s4KvMGzh+twL7DhH1Ww=ZNK9aNE2w@mail.gmail.com>
Subject: Re: [PATCH 12/21 v2] m68k: drop unused Kconfig symbols
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 07:25, Greg Ungerer <gerg@snapgear.com> wrote:
> Geert: are you ok with the changes?

Yep, fine for me.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

BTW, a few of the *_SCC symbols became orphaned, too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
