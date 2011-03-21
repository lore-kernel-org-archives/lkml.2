Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1CUQ6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:58:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47077 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753867Ab1CUQ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:58:29 -0400
Date: Mon, 21 Mar 2011 16:58:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110321165827.GG2570@opensource.wolfsonmicro.com>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
 <20110321153719.GA12325@elte.hu>
 <20110321155836.GE2570@opensource.wolfsonmicro.com>
 <20110321161102.GB23614@elte.hu>
 <20110321163849.GF2570@opensource.wolfsonmicro.com>
 <20110321164937.GA6381@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321164937.GA6381@elte.hu>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 05:49:37PM +0100, Ingo Molnar wrote:
> * Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > That's because the driver code is trivially broken, though - the build
> > test has identified a flaw in the driver which we should fix.

> Trivially broken how? Your mail in the original thread, if i read it right, 
> only claimed that it depends on CONFIG_REGULATOR being present while ideally it 
> should be invariant to the value of CONFIG_REGULATOR:

That's the breakage, yes.  It should be very straightforward to make the
driver build no matter how CONFIG_REGULATOR is set.

>  | Since the regulator on the device is optional this isn't the best fix, the 
>  | code should be updated to support building without regulator.

> If there is some *other* bug there as well then of course it should be fixed 
> instead of worked around.

There's no other bug relevant to this issue.
