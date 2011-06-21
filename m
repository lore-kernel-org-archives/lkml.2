Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab1FUUSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:18:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab1FUUSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:18:47 -0400
Date: Tue, 21 Jun 2011 22:18:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v3.0
Message-ID: <20110621201840.GA27982@elte.hu>
References: <20110621125219.GZ20052@erda.amd.com>
 <20110621130308.GA22088@elte.hu>
 <20110621175451.GD20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621175451.GD20052@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 21.06.11 09:03:08, Ingo Molnar wrote:
> > 
> > Robert,
> > 
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > Ingo,
> > > 
> > > please pull oprofile fixes for v3.0 (tip/perf/urgent):
> > > 
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> > > 
> > > Thanks,
> > > 
> > > -Robert
> > > 
> > > 
> > > The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:
> > > 
> > >   Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)
> > > 
> > > are available in the git repository at:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> > > 
> > > Robert Richter (2):
> > >       oprofile, x86: Fix race in nmi handler while starting counters
> > >       oprofile, x86: Fix nmi-unsafe callgraph support
> > > 
> > >  arch/x86/oprofile/backtrace.c |   56 ++++++++++++++++++++++++++++++++++------
> > >  arch/x86/oprofile/nmi_int.c   |   14 +++++++---
> > >  2 files changed, 57 insertions(+), 13 deletions(-)
> > 
> > Since when has NMI callgraph support been broken?
> 
> I think it never worked correct. But the patch can be backported 
> without conflicts/reworks only for .37 stable kernel. Do you rather 
> like to take it for v3.1?

Yeah, v3.1 would be fine - if it was broken for like 5-10 years then 
it's not eligible for -rc5. The linecount is very high as well, it's 
definitely not a oneliner fix ...

Thanks,

	Ingo
