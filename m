Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1KHKwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:52:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1KHKwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:52:47 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFydrFEKUaSV-JPKXqPc63imZVmaVW0n6Ft_YqoWxp7RQQ@mail.gmail.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
	<20111108031242.GU2203@ZenIV.linux.org.uk>
	<CA+55aFydrFEKUaSV-JPKXqPc63imZVmaVW0n6Ft_YqoWxp7RQQ@mail.gmail.com>
Date: Tue, 8 Nov 2011 11:52:46 +0100
X-Google-Sender-Auth: PMWNGJ5kDGexsxW0GdkGF-Y3YZY
Message-ID: <CAMuHMdXA9zoFyMifj3DZQPB321Z-CkxB2W2eg9oX0rSD7_CJHg@mail.gmail.com>
Subject: Re: Linux 3.2-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 05:26, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> And the binary patches we've always generated the magical git binary
> version of, since there is no traditional format for that at all - and
> it has never been a problem in practice. I think the only binary file
> we have is the logo, and that one doesn't change.

The logos are ASCII PNM files.

There are a few PDFs in Documentation/DocBook/media/{dvb,v4l}/ though
(strange, never noticed them before).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
