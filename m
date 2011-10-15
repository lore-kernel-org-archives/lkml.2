Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1JOO6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 10:58:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54117 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1JOO63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 10:58:29 -0400
Date: Sat, 15 Oct 2011 16:56:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20111015145646.GA9516@elte.hu>
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
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
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

I've already applied the current patches with the SOBs fixed (the 
merge window is getting close), to the tip:x86/platform branch.

Please send any fixes as add-on delta patches against tip:master:

   git://tesla.tglx.de/git/linux-2.6-tip.git

Thanks,

	Ingo
