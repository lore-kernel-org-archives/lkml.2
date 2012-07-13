Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2GMV3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:29:36 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62406 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2GMV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120713210240.GG1707@redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	<20120713210240.GG1707@redhat.com>
Date: Fri, 13 Jul 2012 23:29:34 +0200
X-Google-Sender-Auth: XME9tF69E_c0qa_x6qmAe2fsYQ4
Message-ID: <CAMuHMdUAKsrExGXWdZMZs3ji7Fcf8P-HHqbz-zuznKWFz2+1iw@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:02 PM, Dave Jones <davej@redhat.com> wrote:
> I wish defconfig was actually something useful like this, instead of..
> what the hell is it exactly ? No-one even seems to agree, other than
> "random selection of options, many of which were removed n years ago"

It's just to difficult to update them in a sane way.

I mean, I have my own set of defconfigs for all supported m68k-platforms,
but getting them in sync and ready for submitting an update seems to be a
multi-year project, and there are always more important (and more fun) things
to do. So that's why I haven't gotten to updating them since the defconfig
reduction.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
