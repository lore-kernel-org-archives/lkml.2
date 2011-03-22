Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1CVMYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:24:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59493 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753492Ab1CVMYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:24:23 -0400
Date: Tue, 22 Mar 2011 12:24:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110322122436.GA6834@opensource.wolfsonmicro.com>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
 <20110321153719.GA12325@elte.hu>
 <20110321155836.GE2570@opensource.wolfsonmicro.com>
 <20110321161102.GB23614@elte.hu>
 <20110321163849.GF2570@opensource.wolfsonmicro.com>
 <20110321164937.GA6381@elte.hu>
 <20110321165827.GG2570@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321165827.GG2570@opensource.wolfsonmicro.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 04:58:27PM +0000, Mark Brown wrote:
> That's the breakage, yes.  It should be very straightforward to make the
> driver build no matter how CONFIG_REGULATOR is set.

And indeed it was - in the absence of any response from Zeng I've now
sent a patch for review.
