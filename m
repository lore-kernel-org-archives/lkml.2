Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2GRCd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:33:57 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:49074 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2GRCdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:33:51 -0400
Message-ID: <5006207D.1010708@jonmasters.org>
Date: Tue, 17 Jul 2012 22:33:33 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>  <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>  <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com>  <20120710101018.GE15120@arm.com> <yw1x8vekd309.fsf@unicorn.mansr.com>  <CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com>  <20120717221839.GA4856@arm.com> <1342564536.1898.1.camel@joe2Laptop>
In-Reply-To: <1342564536.1898.1.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 06:35 PM, Joe Perches wrote:
> On Tue, 2012-07-17 at 23:18 +0100, Catalin Marinas wrote:
> 
>> The uname will still report
>> "aarch64" to match the compiler triplet and also avoid confusion of
>> existing 32-bit ARM scripts that simply check for "arm*" in the machine
>> name.
> 
> The compiler triplet seems trivial to change.
> 
> The other bit is a relatively weak argument as the 32bit arm
> scripts can be changed or fixed likely just as easily.

There's a surprising amount of assumption out there around what arm*
means (or doing wildcard matches liberally). I'm glad (from the point of
view of a distribution bootstrap) that we don't have to worry about that
aspect of getting AArch64 support up and running. The directory name is
just that - a name - and unimportant. I like aarch64 from the point of
view of distinguishing "this is not ARM, no, it's not just an extension,
and no it's not just two numbers different or wider regs", but it seems
fairly inevitable that it's going to be arch/arm64. The main thing is
that we understand this isn't like i686->x86_64.

Jon.
