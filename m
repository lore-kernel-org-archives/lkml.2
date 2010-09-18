Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0IRQBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 12:01:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:41896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab0IRQBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 12:01:03 -0400
Message-Id: <20100918155326.478277313@chello.nl>
User-Agent: quilt/0.47-1
Date: Sat, 18 Sep 2010 17:53:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <rmk@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/5] mm, highmem: kmap_atomic rework -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next version of the kmap_atomic rework using Andrew's fancy CPP trickery to
avoid having to convert the whole tree at once.

This is compile tested for i386-allmodconfig, frv, mips-sb1250-swarm,
powerpc-ppc6xx_defconfig, sparc32_defconfig, arm-omap3 (all with
HIGHEM=y).

Tested on Tile by Chris Metcalf.

Boot-tested with: i386-defconfig.

Not tested with:
 - nm10300, the arch doesn't build with highmem to begin with


