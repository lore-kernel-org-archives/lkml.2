Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2GRChC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:37:02 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:56891 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2GRCg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:36:56 -0400
Message-ID: <5006213E.5050007@jonmasters.org>
Date: Tue, 17 Jul 2012 22:36:46 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Pavel Machek <pavel@ucw.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120716121651.GA18859@elf.ucw.cz> <50050ECE.8020100@jonmasters.org> <201207170802.56434.arnd@arndb.de> <20120717105016.3ade44d3@pyramind.ukuu.org.uk>
In-Reply-To: <20120717105016.3ade44d3@pyramind.ukuu.org.uk>
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

On 07/17/2012 05:50 AM, Alan Cox wrote:
>> Right, I would say that with any CPU core more powerful than this one
>> or with more than a few of these, you will also have trouble coming
>> up with workloads that really require the CPU performance but don't
>> also require a 64 bit virtual address space in either user space
>> or kernel.
> 
> There are lots of them - soft radio for example can burn near infinite
> CPU resource depending upon the amount you are fishing out, but its pure
> throughput.

I think A15 is likely to be a good 32-bit story there. Performance wise,
it's awesome. The reason for 64-bit is both emotional ("real servers
must be 64-bit! <pound the table and yell>"), and as an opportunity to
clean up lots of assumptions and have a standard base, but it's not the
end of the 32-bit story. I believe ARM have said many times that they're
not giving up on AArch32, and in fact, if you read the public ISA docs
you'll see additional 32-bit instructions in v8.

Jon.
