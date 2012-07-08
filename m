Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab2GHFFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 01:05:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48058 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab2GHFFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 01:05:36 -0400
X-Sasl-enc: NkaXbWU3tWGK3GKDLhKraUXOViEYIg+CFeWn3p4W2DiK 1341723934
Date: Sun, 8 Jul 2012 02:05:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120708050531.GA17672@khazad-dum.debian.net>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
 <alpine.LNX.2.01.1207080142570.26355@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1207080142570.26355@frira.zrqbmnf.qr>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jul 2012, Jan Engelhardt wrote:
> On Saturday 2012-07-07 21:27, Arnd Bergmann wrote:
> >On Saturday 07 July 2012, Olof Johansson wrote:
> >> > ARM introduced AArch64 as part of the ARMv8 architecture
> >> 
> >> With the risk of bikeshedding here, but I find the name awkward. How
> >> about just naming the arch port arm64 instead?
> >
> >I agree the name sucks, and I'd much prefer to just call it arm64 as
> >well. The main advantage of the aarch64 name is that it's the same
> >as the identifier in the elf triplet, [...] to identify the
> >architecture, [...] the rpm and dpkg architecture names, and [...]
> >the uname syscall.
> 
> Any hindrance changing the specs? There is not even arm64 hardware - or
> aarch64, for that matter - out there yet according to the initial post,
> so I doubt there is anything in userspace yet.

There is, in gnu config (the autoconf config.sub/config.guess stuff), and
maybe some of the gnu toolchain?

I did wonder why the awkward aarch64 identifier instead of something like
arm64 which has also the benefit of good marketing by carrying the ARM name
in the arch name, but since it was not my place to ask about it and ARM had
already submitted "aarch64" to gnu upstream...

If ARM wants to change to a much better "arm64", I suggest ARM should move
*FAST* to get it changed in GNU config and the toolchain.  And tell the
downstream distro maintainers about it... yesterday.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
