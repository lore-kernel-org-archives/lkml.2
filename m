Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2FFNoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:44:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40098 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2FFNoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120530140444.GA10543@frolo.macqel>
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org>
	<20120530102226.GA28628@frolo.macqel>
	<CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com>
	<20120530140444.GA10543@frolo.macqel>
Date: Wed, 6 Jun 2012 15:44:03 +0200
X-Google-Sender-Auth: 9Pv5C9JdZTt_wVdgwKb2Pn6EIBQ
Message-ID: <CAMuHMdW0XqO9iOiuOXrRao_A41L-0iZXXyZugCmiizG=7-VkHg@mail.gmail.com>
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(), and strnlen_user()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 4:04 PM, Philippe De Muyter <phdm@macqel.be> wrote:
>> > Sorry, I did not follow what happened to unaligned accesses, but
>> > CPU32 family (at least 68340) crashes on unaligned accesses.
>>
>> We don't seem to have CONFIG_M68340 in arch/m68k/Kconfig.cpu?
>
> I have a local port here (but based on an ancient linux kernel, 2.6.2 IIRC)

Just to be sure: basically include/asm-m68knommu/unaligned.h has always
been wrong (also in 2.6.2), so you had to fix this locally?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
