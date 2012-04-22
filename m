Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2DVSUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 14:20:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40842 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2DVSUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 14:20:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120422164023.GA32342@elliptictech.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
	<20120422040715.GA30689@elliptictech.com>
	<CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
	<20120422164023.GA32342@elliptictech.com>
Date: Sun, 22 Apr 2012 20:20:32 +0200
X-Google-Sender-Auth: UWMpu4dejgoEMkQ0dGldKfM0BX0
Message-ID: <CAMuHMdVV5-y+hdwwtV67j3dZ2jR-bGWUJngpzvrQ40T+HDB1zA@mail.gmail.com>
Subject: Re: Linux 3.4-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 18:40, Nick Bowler <nbowler@elliptictech.com> wrote:
> (Aside: is there a way to run "git bisect skip" without causing a new
> working tree to be immediately checked out?  When I'm going to be
> picking the next commit manually anyway, having git bisect checkout a
> new tree arbitrarily, potentially forcing a complete recompile (~30
> minutes) when the commit I picked could have been incrementally compiled
> in ~1 minute is pretty annoying...)

I can recommend using ccache for all your compiles.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
