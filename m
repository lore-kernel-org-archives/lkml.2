Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1GGHG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:06:57 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:59740 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab1GGHG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:06:56 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: fix regression in IXP4xx clocksource
References: <m3liwb15t2.fsf@intrepid.localdomain>
	<20110706211442.GY8286@n2100.arm.linux.org.uk>
Date: Thu, 07 Jul 2011 09:06:54 +0200
In-Reply-To: <20110706211442.GY8286@n2100.arm.linux.org.uk> (Russell King's
	message of "Wed, 6 Jul 2011 22:14:42 +0100")
Message-ID: <m3k4buh8mp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> Did you see Thomas' reply to your last patch?  Would you mind responding
> to that please, before asking Linus to merge this?

I like the BE (or endian-neutral value-preserving) accessor idea.
Nevertheless Linux on IXP4xx doesn't even build at this time and I think
fixing this before 3.0 is well worth it.

I assume changing the common ARM code to use new accessors will happen
post-3.0.

(BTW that was Richard Cochran's patch)
-- 
Krzysztof Halasa
