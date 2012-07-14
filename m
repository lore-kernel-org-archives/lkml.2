Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2GNWRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 18:17:15 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:34970 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2GNWRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 18:17:02 -0400
Message-ID: <5001EFCC.4070908@jonmasters.org>
Date: Sat, 14 Jul 2012 18:16:44 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Joe Perches <joe@perches.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>  <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>  <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com>  <20120710101018.GE15120@arm.com> <1341940476.6118.150.camel@joe2Laptop> <4FFC8DA3.6010100@ahsoftware.de>
In-Reply-To: <4FFC8DA3.6010100@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 198.254.247.168
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 04:16 PM, Alexander Holler wrote:

> And it isn't so that the name will have to be used that seldom, at least 
> every distribution would need to use it to name the flavour, like e.g. 
> "Fedora AArch64hf" or "Debian AArch64".

The good news is we won't need an "hf" release because we're all going
to just agree on the ABI on day one, and standardize the paths, and all
the distros are going to live happily ever after[0].

Jon.

[0] The first part at least is actually true. There is an ABI that I
reviewed a long time back (you can download it), and we assume the
presence of all kinds of previously optional stuff...like the fp.
