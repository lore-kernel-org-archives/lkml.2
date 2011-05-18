Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1ERMLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:11:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41183 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab1ERMLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:11:11 -0400
Date: Wed, 18 May 2011 14:10:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
Message-ID: <20110518121013.GC6210@elte.hu>
References: <20110517080029.GB22093@elte.hu>
 <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com>
 <20110517113634.GC13475@elte.hu>
 <4DD2BEFB.6070609@mit.edu>
 <m2hb8typxt.fsf@firstfloor.org>
 <alpine.LFD.2.02.1105172354040.3078@ionos>
 <BANLkTik9+UGLvPCLYO246N4fMxJ5F=vHwA@mail.gmail.com>
 <alpine.LFD.2.02.1105180839370.3078@ionos>
 <20110518083147.GD14805@elte.hu>
 <BANLkTi=cqjGDD7X8u_7LDGZh7KqFZo6h+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=cqjGDD7X8u_7LDGZh7KqFZo6h+w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> Should we add a vDSO vtime for 2.6.40 so that people can start using it?

yeah.

Thanks,

	Ingo
