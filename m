Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2LUCoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:44:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:50010 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab2LUCoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:44:03 -0500
Message-ID: <1356057805.5397.58.camel@pasglop>
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        maxime.ripard@free-electrons.com, David Miller <davem@davemloft.net>
Date: Fri, 21 Dec 2012 13:43:25 +1100
In-Reply-To: <CA+55aFyiRPk0Qta35PBqMFqn+GkKaugqKJM3WHCT0JEJ1YohWw@mail.gmail.com>
References: <20121220163814.GA29557@quad.lixom.net>
	 <20121220175639.GA14363@n2100.arm.linux.org.uk>
	 <CAOesGMgxXmXUW2RP_5AxJ6Z5sRBhFJ2CQz4S12MwXAb3=ibYOA@mail.gmail.com>
	 <20121220184525.GC21056@atomide.com>
	 <CA+55aFyiRPk0Qta35PBqMFqn+GkKaugqKJM3WHCT0JEJ1YohWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 11:00 -0800, Linus Torvalds wrote:
> Hmm. The patch there looks better than any alternative I can think of.
> It uses the same spinlock name for the whole array, but I think it's
> only used for lockdep printouts, so that should be fine.
> 
> Send me the patch with signed-off and tested-by, and perhaps have a
> few more people test it. The powerpc and sparc people both use it in
> their 32-bit versions and have responsible maintainers, so it might be
> worth it double-checking with BenH and DaveM about it, just in case.
> Added to the Cc.

The patch looks fine. I won't personally be able to test it until after
I'm back from vacation though. I'll see if I can get somebody else to
but don't wait for me.

Cheers,
Ben.


