Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab1FFRvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:51:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48717 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab1FFRvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:51:08 -0400
Date: Mon, 6 Jun 2011 19:50:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, pageexec@freemail.hu, Mikael Pettersson <mikpe@it.uu.se>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86-64: Clean up vsyscall emulation and remove
 fixed-address ret
Message-ID: <20110606175057.GB6412@elte.hu>
References: <cover.1307380481.git.luto@mit.edu>
 <bd468a0e02befab146667fab5de57df7332d54d9.1307380481.git.luto@mit.edu>
 <20110606174129.GA6412@elte.hu>
 <BANLkTikudFYgtueTAdQjAeEMn1MgjmmM9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikudFYgtueTAdQjAeEMn1MgjmmM9g@mail.gmail.com>
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

> >>  arch/x86/include/asm/vsyscall.h   |   10 ++++-
> >>  arch/x86/kernel/vsyscall_64.c     |   78 +++++++++++--------------------------
> >>  arch/x86/kernel/vsyscall_emu_64.S |   17 +--------
> >>  3 files changed, 32 insertions(+), 73 deletions(-)
> >
> > Ok, this makes the whole series a lot more palatable!
> >
> > Can i propagate the rename suggested by hpa into patch #3:
> >
> >  CONFIG_COMPAT_VSYSCALL => CONFIG_LEGACY_VSYSCALL
> 
> Certainly!  CONFIG_LEGACY_VTIME might be even better, but I'm fine
> with any renaming you'd like to do.

Good point, i changed it to CONFIG_LEGACY_VTIME - this correctly 
implies that it's only about vtime(), not about any other vsyscall.

Thanks,

	Ingo
