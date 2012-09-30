Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab2I3RCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 13:02:07 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:34633 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2I3RCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 13:02:06 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ARM SoC tree, Was: Re: [PATCH 05/12] ARM: ixp4xx: use __iomem for MMIO
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
	<1348868177-21205-6-git-send-email-arnd@arndb.de>
	<m3lift6rru.fsf_-_@intrepid.localdomain>
	<201209291458.16112.arnd@arndb.de>
	<m3y5jskbir.fsf@intrepid.localdomain>
	<20120929174400.GA6933@n2100.arm.linux.org.uk>
	<m3pq54jyqw.fsf@intrepid.localdomain>
	<20120929215355.GD6933@n2100.arm.linux.org.uk>
Date: Sun, 30 Sep 2012 19:01:59 +0200
In-Reply-To: <20120929215355.GD6933@n2100.arm.linux.org.uk> (Russell King's
	message of "Sat, 29 Sep 2012 22:53:55 +0100")
Message-ID: <m3vcevtpfc.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

>> Note I'm not only doing ARM, but also X86 and MIPS, with additional code
>> shared between them, and the "stable" part of it is what I'm paid for.
>> I can't simply work with arm-soc, none of my platforms will even boot
>> with pure arm-soc.
>
> I'm assuming that Linus' -rc kernels work for you, yes?

No, but it's OK :-)

I meant I need additional code for a) ARM and MIPS-based boards (off the
shelf by Ubiquity, Gateworks etc., support ported mostly from OpenWRT),
b) custom hardware used only by us.

I hope to eventually submit a) upstream, then arm-soc and Linus' trees
would work for me. I know it's a mess, but for now I have no options.

BTW the situation with hardware supported only by OpenWRT is a part of
the equation.
-- 
Krzysztof Halasa
