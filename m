Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0JNXFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:05:15 -0400
Received: from borg.medozas.de ([188.40.89.202]:39245 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0JNXFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:05:13 -0400
Date: Fri, 15 Oct 2010 01:05:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, agruen@suse.de, davem@davemloft.net,
        andi@firstfloor.org
Subject: Re: Process to push changes to include/linux/types.h
In-Reply-To: <AANLkTik+NENndwKFSFQoVAr0qiBWg5HOsQdVPmtNaSjC@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1010150048340.17853@obet.zrqbmnf.qr>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com> <20101014125458.9e51ac58.akpm@linux-foundation.org> <alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr> <20101014143723.ffea0d8c.akpm@linux-foundation.org> <alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr>
 <AANLkTik+NENndwKFSFQoVAr0qiBWg5HOsQdVPmtNaSjC@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-10-15 00:13, Linus Torvalds wrote:
>
>Extended background for non-git people: git _internally_ only uses the
>160-bit SHA1 (which in its full ASCII form is 40 hex characters). But
>because that is so human-unfriendly, there are various human-readable
>ways to express it.
>[...]
>   I tend to use the 12-character short version in commit messages,
>for example. The full 40-character SHA1 makes it hard to do any sane
>line breaks with in the commit message.

I tend to use describe --tags (rev expr) output; unlike 12-char
versions, they cannot become ambiguous at any time. If git also used
the initial portion of regular describes ("v2.6.24-1234-"), it would
be similarly strengthened. Yes, I'm just theoretically projecting
what happens if \lim_{time,hackers -> \infty}...

>It's worth noting that the "v2.6.24-6165" - while human-readable and
>thus useful - is technically meaningless. Since development isn't a
>straight line, "6165 commits after 2.6.24" is really not a
>well-defined point.

It could be - in totally linear developments. (Postgresql, anyone?)

>In contrast, the "v2.6.25-rc1~1089^2~98" expression is actually
>well-defined. There is no ambiguity there, but it's also obviously not
>really all that human-readable.

I beg to differ. It tells you that the certain commit was included
for v2.6.25-rc1. That's much more telling than v2.6.24-1234-gabcdef1.
Especially when a branch has not been recently merged, it could be
showing v2.6.22-9876-gxxx or anything further back in time.


Jan
