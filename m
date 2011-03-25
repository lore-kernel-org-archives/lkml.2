Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1CYTkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:40:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52715 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab1CYTkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:40:14 -0400
Date: Fri, 25 Mar 2011 20:40:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT pull] irq cleanups for .39
Message-ID: <20110325194010.GG22960@elte.hu>
References: <alpine.LFD.2.00.1103251747450.31464@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103251747450.31464@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Linus,
> 
> Please pull the latest irq-cleanup-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-cleanup-for-linus
> 
> This contains the irq/urgent bits which Ingo asked to pull earlier, so
> whatever you pull first does not matter.
> 
> The gpio patches have been acked by Grant.
> 
> The avr, h8300, xtensa, m32r, um bits is stuff which got ignored by
> the arch maintainers. Those archs seem to be orphaned. 
> 
> The cleanup is necessary as we really want to get rid of all the
> deprecated and compat stuff asap.

Note, while the architectures are orphaned, i've done cross-build testing for 
most of these architectures with your changes applies, so the ones that built 
before should still work now.

Thanks,

	Ingo
