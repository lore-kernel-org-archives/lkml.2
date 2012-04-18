Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab2DRHss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:48:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43188 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2DRHsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:48:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120418030524.GD21302@windriver.com>
References: <20120418030524.GD21302@windriver.com>
Date: Wed, 18 Apr 2012 09:48:46 +0200
X-Google-Sender-Auth: dbNAY4vsCfst1vg_420GSUKMUZI
Message-ID: <CAMuHMdU2LR2xKNsdq6mPENSZsWU0MxExwbL9NK2x=6eTMr+k+w@mail.gmail.com>
Subject: Re: linux-next: triage for April 17, 2012
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 05:05, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> m68k:allmodconfig
>        when:   Mar 16
>        why:    persistent_ram.c: implicit declaration of 'memblock_reserve'
>        status:
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5884324/
>        ref:    http://www.spinics.net/lists/linux-next/msg19343.html

This has been fixed since a while.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
