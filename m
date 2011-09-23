Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab1IWE6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 00:58:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47895 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab1IWE6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 00:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxm86xohU4nSuDWe_Ru9SU79x1sLHNdm4nFHyJNH4=mBQ@mail.gmail.com>
References: <alpine.DEB.2.00.1109222140510.8856@ayla.of.borg>
	<CA+55aFxm86xohU4nSuDWe_Ru9SU79x1sLHNdm4nFHyJNH4=mBQ@mail.gmail.com>
Date: Fri, 23 Sep 2011 06:58:17 +0200
X-Google-Sender-Auth: zx9ytRPIr9dn1spIgF-yRDrRhOA
Message-ID: <CAMuHMdUnVr+mYr4hgbfSi9n5iMmHGxTK-_E8y-sKn=HOiEAkMw@mail.gmail.com>
Subject: Re: [PATCH] zorro: Defer device_register() until all devices have
 been identified
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?Q?Ingo_J=C3=BCrgensmann?= <ij@2011.bluespice.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 22:01, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 22, 2011 at 12:47 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>>
>> Authorization code F68KAMYRULEZ.
>
> EUNAUTHORIZED.

I thought we used negative error codes? ;-)

> But applied anyway,

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
