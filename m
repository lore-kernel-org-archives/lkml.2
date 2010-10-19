Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0JSEsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:48:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45990 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab0JSEsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 00:48:53 -0400
Date: Tue, 19 Oct 2010 15:48:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the tip tree with the powerpc tree
Message-Id: <20101019154849.126a736a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/powerpc/kernel/time.c between commit
cf9efce0ce3136fa076f53e53154e98455229514 ("powerpc: Account time using
timebase rather than PURR") from the powerpc tree and commit
e360adbe29241a0194e10e20595360dd7b98a2b3 ("irq_work: Add generic hardirq
context callbacks") from the tip tree.

Just context changes.  I fixed it up and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
