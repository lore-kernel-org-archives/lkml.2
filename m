Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2IXPOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:14:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53713 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab2IXPOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120924135614.24704.qmail@science.horizon.com>
References: <xa1tfw67d24j.fsf@mina86.com>
	<20120924135614.24704.qmail@science.horizon.com>
Date: Mon, 24 Sep 2012 17:14:00 +0200
X-Google-Sender-Auth: y1Yq_1IJjg_98rCYZ98j8JRdwlI
Message-ID: <CAMuHMdUt3WvLgt73L39BZ4D5_qDr7ZCYhTz6RDEsH4qV2vSa7g@mail.gmail.com>
Subject: Re: [PATCH 2/4] lib: vsprintf: Optimize division by 10000
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: George Spelvin <linux@horizon.com>
Cc: mpn@google.com, vda.linux@googlemail.com, hughd@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 3:56 PM, George Spelvin <linux@horizon.com> wrote:
> Michal Nazarewicz <mpn@google.com> wrote:
>> Didn't some SPARCs have 32x32->32 multiply?  I remember reading some
>> rant from a GMP developer about how SPARC is broken that way.
>
> SPARCv9 only has 64x64->64; there's no 128-bit result version.
> That cuts large-integer math speed by a factor of 4 (very
> crude approximation), to the same speed as 32x32->64.
>
> SPARCv8 UMUL puts the high half of the 64-bit result into the Y
> register, and SPARCv7 has a multiply-step instruction (MULScc) which
> does likewise.

Early SPARCs don't even have a multiply instruction.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
