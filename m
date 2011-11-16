Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1KPFnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 00:43:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60183 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab1KPFnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 00:43:51 -0500
Date: Wed, 16 Nov 2011 06:41:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20111116054156.GA20847@elte.hu>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20111012153415.GA26529@elte.hu>
 <20111016014203.1dfb2cb8@lenov0n>
 <20111015145646.GA9516@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111015145646.GA9516@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:
> 
> > On Wed, 12 Oct 2011 17:34:15 +0200,
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:
> > > 
> > > > From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > > > 
> > > > 
> > > > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > > 
> > > That's not a valid signoff sequence. Did you intend this to be:
> > > 
> > >   From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > >  
> > >   Signed-off-by: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > >   Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > > 
> > > ?
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > 
> > Yes, this should be signed off by Jonas Fonseca as well. This will 
> > be updated in the next patches set.
> 
> I've already applied the current patches with the SOBs fixed (the 
> merge window is getting close), to the tip:x86/platform branch.
> 
> Please send any fixes as add-on delta patches against tip:master:
> 
>    git://tesla.tglx.de/git/linux-2.6-tip.git

(tap, tap, is this thing on?)

Should i drop these commits:

 32a85aa727ce: x86/platform: Add TS-5500 ADC support
 3a338d79aa95: x86/platform: Add TS-5500 LED support
 2437b498abac: x86/platform: Add TS-5500 GPIO support
 37f9a16c166c: x86/platform: Add TS-5500 base support

from tip:x86/platform?

Had this (probably trivial) build failure been fixed when i reported 
it over a month ago then these commits could have been included in 
the v3.2 upstream kernel - now they will probably have to be delayed 
to v3.3.

Thanks,

	Ingo
