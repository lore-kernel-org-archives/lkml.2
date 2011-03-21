Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1CUQtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:49:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab1CUQtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:49:51 -0400
Date: Mon, 21 Mar 2011 17:49:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110321164937.GA6381@elte.hu>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
 <20110321153719.GA12325@elte.hu>
 <20110321155836.GE2570@opensource.wolfsonmicro.com>
 <20110321161102.GB23614@elte.hu>
 <20110321163849.GF2570@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321163849.GF2570@opensource.wolfsonmicro.com>
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


* Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Mar 21, 2011 at 05:11:02PM +0100, Ingo Molnar wrote:
> > * Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > > As indicated that's not a good fix since the affected code is all runtime 
> > > conditional already. [...]
> 
> > Well, AFAICS Randy's patch correctly expresses current infrastructure 
> > dependencies the driver has.
> 
> That's because the driver code is trivially broken, though - the build
> test has identified a flaw in the driver which we should fix.

Trivially broken how? Your mail in the original thread, if i read it right, 
only claimed that it depends on CONFIG_REGULATOR being present while ideally it 
should be invariant to the value of CONFIG_REGULATOR:

 | Since the regulator on the device is optional this isn't the best fix, the 
 | code should be updated to support building without regulator.

If there is some *other* bug there as well then of course it should be fixed 
instead of worked around.

Thanks,

	Ingo
