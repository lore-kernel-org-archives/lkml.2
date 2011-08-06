Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab1HFGyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 02:54:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51354 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1HFGyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 02:54:16 -0400
Date: Sat, 6 Aug 2011 08:53:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jinyoung Park <jinyoungp@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: aat2870 causes build failure in current upstream
Message-ID: <20110806065312.GD13220@elte.hu>
References: <4E385B53.3040108@zytor.com>
 <20110804171725.GA12729@elte.hu>
 <4E3B87C2.3020304@nvidia.com>
 <4E3C18D7.9070303@zytor.com>
 <20110805173857.b1a23e59.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805173857.b1a23e59.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Fri, 05 Aug 2011 09:22:47 -0700 H. Peter Anvin wrote:
> 
> > On 08/04/2011 11:03 PM, Jinyoung Park wrote:
> > > Hi,
> > > 
> > > I try to check allmodconfig error issue for aat2870 backlight driver.
> > > But I could not observing error message what you attached, building is
> > > successed.
> > > Please let me know how to reproduce allmodconfig problem for aat2870
> > > backlight driver.
> > > 
> > > This is my repro step.
> > > $ git clone
> > > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > > $ cd linux-next
> > > $ make allmodconfig
> > > $ make
> > > 
> > > Thanks,
> > > Jin.
> > > 
> > 
> > Get Linus' current tree, not linux-next.
> 
> Now fixed?  current mainline i386 allmodconfig builds OK for me.

Yeah, works ok for me with latest -git as well so something fixed it.

Thanks,

	Ingo
