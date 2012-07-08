Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2GHU22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 16:28:28 -0400
Received: from seven.medozas.de ([5.9.24.206]:58094 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab2GHU21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 16:28:27 -0400
Date: Sun, 8 Jul 2012 22:28:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
In-Reply-To: <20120708050531.GA17672@khazad-dum.debian.net>
Message-ID: <alpine.LNX.2.01.1207082226150.22454@frira.zrqbmnf.qr>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <alpine.LNX.2.01.1207080142570.26355@frira.zrqbmnf.qr>
 <20120708050531.GA17672@khazad-dum.debian.net>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 2012-07-08 07:05, Henrique de Moraes Holschuh wrote:
>>>
>>>I agree the name sucks, and I'd much prefer to just call it arm64 as
>>>well. The main advantage of the aarch64 name is that it's the same
>>>as the identifier in the elf triplet, [...] to identify the
>>>architecture, [...] the rpm and dpkg architecture names, and [...]
>>>the uname syscall.
>>
>>Any hindrance changing the specs? There is not even arm64 hardware - or
>>aarch64, for that matter - out there yet according to the initial post,
>>so I doubt there is anything in userspace yet.
>
>There is, in gnu config (the autoconf config.sub/config.guess stuff), and
>maybe some of the gnu toolchain?
>
>I did wonder why the awkward aarch64 identifier instead of something like
>arm64 which has also the benefit of good marketing by carrying the ARM name
>in the arch name, but since it was not my place to ask about it and ARM had
>already submitted "aarch64" to gnu upstream...

Well maybe ARM just wants to render itself unimportant. Fine by me, but 
the shareholders might think differently ;-)
