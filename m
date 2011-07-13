Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1GMUvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:51:08 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:51043 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1GMUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:51:07 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jul 2011 16:51:07 EDT
Date: Wed, 13 Jul 2011 16:51:01 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Pavel Machek <pavel@ucw.cz>
Cc: stable@kernel.org, Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
In-reply-to: <20110420131442.GA29418@atrey.karlin.mff.cuni.cz>
Message-id: <alpine.LFD.2.02.1107131647140.9546@x980>
References: <alpine.LFD.2.02.1103301819250.31342@x980>
 <20110414090854.GB9248@elte.hu> <alpine.LFD.2.02.1104150202310.29365@x980>
 <20110420131442.GA29418@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok. So... what "serious bug" does this fix? You really need to use cc:
> stable less. Tweaking performance/power ratio is _not_ serious bug.

While the performance difference may not be significant,
the energy difference may be.

Some people think it is serious when Linux has worse out-of-box
energy efficiency than Windows on the same hardware.

Some people think that it is serious when their Linux distribution
has worse energy efficiency than competing Linux distributions.

Greg has given me a hard time for not cc'ing stable _enough_.
I guess the folks that answer the stable mail get to decide...

cheers,
-Len

