Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2GQWfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:35:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43328 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756225Ab2GQWfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:35:37 -0400
Message-ID: <1342564536.1898.1.camel@joe2Laptop>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
From: Joe Perches <joe@perches.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 17 Jul 2012 15:35:36 -0700
In-Reply-To: <20120717221839.GA4856@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
	 <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com>
	 <20120710101018.GE15120@arm.com> <yw1x8vekd309.fsf@unicorn.mansr.com>
	 <CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com>
	 <20120717221839.GA4856@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 23:18 +0100, Catalin Marinas wrote:

> The uname will still report
> "aarch64" to match the compiler triplet and also avoid confusion of
> existing 32-bit ARM scripts that simply check for "arm*" in the machine
> name.

The compiler triplet seems trivial to change.

The other bit is a relatively weak argument as the 32bit arm
scripts can be changed or fixed likely just as easily.




