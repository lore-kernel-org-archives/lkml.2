Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0FWTzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:55:33 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46702 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0FWTza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=j3+rW1N22UVs+ULNBS7WZLNuteYVTx07+wId0JKCYZZgbfxB9uec/QfplGOiSS6aaC
         1j9DWMXRoMXmlTqijJujcze0k6/G0FmHSR3cBdrX+ed8sCunop+wjQdRuVmwJXG4mcru
         h1QYu9j3TCb4KGwKcoteC3+aTHKtlHdy/6LYg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1006131208470.18415@ayla.of.borg>
References: <alpine.DEB.2.00.1006131208470.18415@ayla.of.borg>
Date: Wed, 23 Jun 2010 21:55:27 +0200
X-Google-Sender-Auth: WQJLduFbs-eq2xEcmTPoQHqqju4
Message-ID: <AANLkTikdDZf1zvgtu3DjuMoabHBo43zY6H_AUKn0Q5Qz@mail.gmail.com>
Subject: Re: [PATCH] rtc: rp5c01 - Add NVRAM support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Arno Griffioen <arno.griffioen@ieee.org>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, rtc-linux@googlegroups.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 12:12, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> The Ricoh RP5C01 RTC contains 26 x 4 bits of NVRAM.
> Provide access to it via a sysfs "nvram" attribute file.

I also created a small tool to correct NVRAM checksums, interprete the
contents, and
modify individual NVRAM fields on Amiga 3000/4000.
You can find it at
git://git.kernel.org/pub/scm/linux/kernel/git/geert/amiga-nvram.git.

BTW, does anyone (Arno?) know the meaning of the AMIX-specific bits (32-63)?
battmembitsamix.h just says "See Amix documentation for these bit definitions".
I also couldn't find anything about it at http://www.amigaunix.com/.

Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
