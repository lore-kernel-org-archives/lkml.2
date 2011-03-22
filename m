Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1CVPjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:39:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59502 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1CVPjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:39:33 -0400
Date: Tue, 22 Mar 2011 08:38:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ingo Molnar <mingo@elte.hu>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-Id: <20110322083839.caab0520.randy.dunlap@oracle.com>
In-Reply-To: <20110322122436.GA6834@opensource.wolfsonmicro.com>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
	<20110321153719.GA12325@elte.hu>
	<20110321155836.GE2570@opensource.wolfsonmicro.com>
	<20110321161102.GB23614@elte.hu>
	<20110321163849.GF2570@opensource.wolfsonmicro.com>
	<20110321164937.GA6381@elte.hu>
	<20110321165827.GG2570@opensource.wolfsonmicro.com>
	<20110322122436.GA6834@opensource.wolfsonmicro.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D88C284.015A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 12:24:36 +0000 Mark Brown wrote:

> On Mon, Mar 21, 2011 at 04:58:27PM +0000, Mark Brown wrote:
> > That's the breakage, yes.  It should be very straightforward to make the
> > driver build no matter how CONFIG_REGULATOR is set.
> 
> And indeed it was - in the absence of any response from Zeng I've now
> sent a patch for review.
> --

Hi,
Where was the patch sent, please?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
