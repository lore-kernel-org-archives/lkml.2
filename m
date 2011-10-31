Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab1JaRIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:08:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39617 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab1JaRIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:08:14 -0400
MIME-Version: 1.0
In-Reply-To: <4EAE1B3A.7010303@snapgear.com>
References: <1319835295-19519-1-git-send-email-geert@linux-m68k.org>
	<4EAE1B3A.7010303@snapgear.com>
Date: Mon, 31 Oct 2011 18:08:13 +0100
X-Google-Sender-Auth: 5877kLfIc55jNU14uv71oAg0yto
Message-ID: <CAMuHMdXSMcbb3AOtwj2pErSsGQpUDXq98ziyZLvumFgRSDqDaw@mail.gmail.com>
Subject: Re: [PATCH] m68k: Revive lost DIO bus config option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Oct 31, 2011 at 04:51, Greg Ungerer <gerg@snapgear.com> wrote:
> On 29/10/11 06:54, Geert Uytterhoeven wrote:
>> commit 0e152d80507b75c00aac60f2ffc586360687cd52 ("m68k: reorganize Kconfig
>> options to improve mmu/non-mmu selections") accidentally dropped the DIO
>> bus config option. Re-add it to the "Bus support" section.
>>
>> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
>
> Oops, another one.

That's the last one. I double checked all config changes in my test trees.

> Acked-by: Greg Ungerer <gerg@uclinux.org>
>
> Are you going to push these to Linus, or do you want me to
> collect these fixes and push?

I've added these to my for-3.2 branch, to push out after v3.2-rc1.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
