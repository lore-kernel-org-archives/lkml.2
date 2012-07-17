Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2GQHGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:06:16 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:59726 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2GQHGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:06:01 -0400
Message-ID: <50050ECE.8020100@jonmasters.org>
Date: Tue, 17 Jul 2012 03:05:50 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120714093032.GA23316@elf.ucw.cz> <20120715121644.GB10597@arm.com> <201207151943.08183.arnd@arndb.de> <20120715213336.GA25830@arm.com> <20120716121651.GA18859@elf.ucw.cz>
In-Reply-To: <20120716121651.GA18859@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 08:16 AM, Pavel Machek wrote:

>> If an implementation supports AArch32 at EL3 there could be some
>> physical (or some FPGA config) switch to choose between the two. But
>> since AArch64 is mandated, I don't see why one would force AArch32 at
>> EL3 and therefore all lower exception levels (and make a big part of the
>> processor unused).
> 
> Actually I see one ... and I can bet it will happen.
> 
> So you create that shiny new ARMv8 compliant CPU, 8 cores, 2GHz. HTC
> will want to use it with 1GB of RAM... and put around exiting OMAP
> perihepals.

But that's why we have Eagle (A15). It's a very capable 32-bit design
from ARM and far more sensible for such designs. You can easily build
something with a few A15 clusters in it, as we're already seeing.

Jon.
