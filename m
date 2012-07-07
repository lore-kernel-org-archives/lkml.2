Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2GGXpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:45:20 -0400
Received: from seven.medozas.de ([5.9.24.206]:52578 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab2GGXpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:45:18 -0400
Date: Sun, 8 Jul 2012 01:45:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Olof Johansson <olof@lixom.net>, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
In-Reply-To: <201207071927.13135.arnd@arndb.de>
Message-ID: <alpine.LNX.2.01.1207080142570.26355@frira.zrqbmnf.qr>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-07-07 21:27, Arnd Bergmann wrote:
>On Saturday 07 July 2012, Olof Johansson wrote:
>
>> > ARM introduced AArch64 as part of the ARMv8 architecture
>> 
>> With the risk of bikeshedding here, but I find the name awkward. How
>> about just naming the arch port arm64 instead?
>
>I agree the name sucks, and I'd much prefer to just call it arm64 as
>well. The main advantage of the aarch64 name is that it's the same
>as the identifier in the elf triplet, [...] to identify the
>architecture, [...] the rpm and dpkg architecture names, and [...]
>the uname syscall.

Any hindrance changing the specs? There is not even arm64 hardware - or
aarch64, for that matter - out there yet according to the initial post,
so I doubt there is anything in userspace yet.
