Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1FIHPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:15:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab1FIHPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:15:34 -0400
Date: Thu, 9 Jun 2011 09:15:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v3.0
Message-ID: <20110609071527.GD20544@elte.hu>
References: <1306860406-6094-1-git-send-email-robert.richter@amd.com>
 <20110608125346.GL20052@erda.amd.com>
 <20110608140631.GA30752@elte.hu>
 <20110609070237.GO20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609070237.GO20052@erda.amd.com>
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

> On 08.06.11 10:06:31, Ingo Molnar wrote:
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
> > > The following changes since commit d7ebe75b065a7c2d58ffc12f9d2e00d5ea4e71eb:
> > > 
> > >   perf: Fix comments in include/linux/perf_event.h (2011-06-04 12:31:14 +0200)
> > > 
> > > are available in the git repository at:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> > > 
> > > Robert Richter (4):
> > >       oprofile, x86: Add comments to IBS LVT offset initialization
> 
> Ingo,
> 
> it seems you pulled (86dd7909c2c4ae3f219a9233bf0f095b05632ecf) from
> 
>  cbf74cea070fa1f705de4712e25d9e56ae6543c7 (oprofile, x86: Add comments to IBS LVT offset initialization)
> 
> These ones are still missing:
> 
> > >       oprofile: Free potentially owned tasks in case of errors
> > >       oprofile: Fix locking dependency in sync_start()
> > >       oprofile, dcookies: Fix possible circular locking dependency
> 
> But oprofile/urgent is
> 
>  fe47ae7f53e179d2ef6771024feb000cbb86640f (oprofile, dcookies: Fix possible circular locking dependency)
> 
> Is this intended? Maybe a korg git sync issue?

Yeah, probably - and i reviewed the on-lkml patches you sent earlier 
and didnt notice that these three are missing from the pull request. 
I pulled again and the bits are there now.

Thanks,

	Ingo
