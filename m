Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2HOQet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:34:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60382 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2HOQer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <201208151330.02112.arnd@arndb.de>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
	<1344966752-16102-5-git-send-email-catalin.marinas@arm.com>
	<201208151330.02112.arnd@arndb.de>
Date: Wed, 15 Aug 2012 18:34:46 +0200
X-Google-Sender-Auth: otgEEInDBSbPkCmyKTVwFKu2rW8
Message-ID: <CAMuHMdUEKNYFAU4N8KnJ0DPYgW7BRtaaJQSARDJCVjQOU2bFBw@mail.gmail.com>
Subject: Re: [PATCH v2 04/31] arm64: MMU definitions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 3:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> +#define TCR_IPS_40BIT                (2 << 32)

By default, constants are int, i.e. 32-bit. So you must write

2ULL << 32

>> +#define TCR_ASID16           (1 << 36)

1ULL

> As a matter of coding style, I would much prefer tables like this to be
> written as
>
> #define TCR_IRGN_MASK           0x0000000003000300

0x0000000003000300ULL, to be safe

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
