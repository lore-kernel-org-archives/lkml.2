Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1KOCc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:32:58 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:45576
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755034Ab1KOCc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:32:57 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: <linuxppc-dev@lists.ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>, <benh@kernel.crashing.org>,
        <galak@kernel.crashing.org>, <scottwood@freescale.com>,
        <B04825@freescale.com>, <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 0/2] powerpc: CPU cache op cleanup
Date: Mon, 14 Nov 2011 21:32:09 -0500
Message-Id: <1321324332-22964-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320986410.21206.48.camel@pasglop>
References: <1320986410.21206.48.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so I have a work-in-progress patch for cleaning up the CPU cache
handling, and I'd like some comments on the approach.

It's not really split up, and it's kind of a huge patch because it
tries to tackle a lot of things at once.  Unfortunately, I'm having a
hard time finding good clean places to break things apart.

Furthermore, I know 100% that it is not complete on PPC32 yet, and it
almost certainly does not build on PPC64 yet either.

These are the only files in arch/powerpc/ which have known-incorrect
references to L1_CACHE_* variables:
  arch/powerpc/lib/copy_32.S
  arch/powerpc/kernel/misc_32.S

Unfortunately, I've been staring at PPC asm for long enough that I
have a migraine headache and I'm going to have to stop here for now.
If somebody else wants to tackle fixing up the 32-bit copy_page() and
__copy_tofrom_user() routines it would be highly appreciated.

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

