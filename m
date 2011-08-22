Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1HVU7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:59:43 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:63371 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1HVU7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:59:41 -0400
MIME-Version: 1.0
In-Reply-To: <1314030548-21082-4-git-send-email-akinobu.mita@gmail.com>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
	<1314030548-21082-4-git-send-email-akinobu.mita@gmail.com>
Date: Mon, 22 Aug 2011 22:59:40 +0200
X-Google-Sender-Auth: izEDF0WlOnF6naDtec5YXfbR1wg
Message-ID: <CAMuHMdVUvLAYpGDKsDUJ0DkLJEJKHCRy2Cj6miAH1YyEL6iWpw@mail.gmail.com>
Subject: Re: [PATCH 3/4] string: introduce memchr_inv
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joern Engel <joern@logfs.org>, logfs@logfs.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 18:29, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> +/**
> + * memchr_inv - Find a character in an area of memory.

This description doesn't really match.

> + * @s: The memory area
> + * @c: The byte to search for
> + * @n: The size of the area.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
