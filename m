Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab1JZPnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:43:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043Ab1JZPne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:43:34 -0400
Date: Wed, 26 Oct 2011 17:41:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20111026154151.GA1588@elte.hu>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20111012153415.GA26529@elte.hu>
 <20111016014203.1dfb2cb8@lenov0n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111016014203.1dfb2cb8@lenov0n>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:

> On Wed, 12 Oct 2011 17:34:15 +0200,
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:
> > 
> > > From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > > 
> > > 
> > > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > 
> > That's not a valid signoff sequence. Did you intend this to be:
> > 
> >   From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> >  
> >   Signed-off-by: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> >   Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > 
> > ?
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Yes, this should be signed off by Jonas Fonseca as well. This will 
> be updated in the next patches set.

Note that the patches are currently stalled, due to the build bug i 
reported. They won't be able to make it into the v3.2 upstream kernel 
if the bug is not fixed in time.

The patches are in the -tip tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

in the x86/platform branch (also integrated into the master branch).

Thanks,

	Ingo
