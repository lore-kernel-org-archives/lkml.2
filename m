Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1CPMHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 08:07:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1CPMHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 08:07:37 -0400
Date: Wed, 16 Mar 2011 13:07:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/platform changes for v2.6.39
Message-ID: <20110316120723.GA23417@elte.hu>
References: <20110315213223.GA21481@elte.hu>
 <20110315230943.GA8464@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315230943.GA8464@angua.secretlab.ca>
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


* Grant Likely <grant.likely@secretlab.ca> wrote:

> On Tue, Mar 15, 2011 at 10:32:23PM +0100, Ingo Molnar wrote:
> > Linus,
> > 
> > Please pull the latest x86-platform-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-platform-for-linus
> > 
> > 
> > out-of-topic modifications in x86-platform-for-linus:
> > -----------------------------------------------------
> 
> ... all merged in from my devicetree/next branch which Thomas and I
> discussed before hand.

Yeah. We auto-generate these notifiers for all arch/x86/ pull requests that come 
from -tip, to not surprise Linus with any modification he might not expect from an 
x86 topic, and to give us a final chance to catch any unintended out-of-tree 
modifications ourselves.

The sha1's can be used to check the individual commits easily and as you say they 
come with acks from affected maintainers.

> [...]  I agree with this pull.

Thanks,

	Ingo
