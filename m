Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1CNMNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:13:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56267 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab1CNMNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:13:46 -0400
Date: Mon, 14 Mar 2011 13:13:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Schwab <schwab@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Beulich <JBeulich@novell.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, binutils@sourceware.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Modra <amodra@gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314121321.GE23257@elte.hu>
References: <20110311165802.GA3508@intel.com>
 <4D7A64670200007800035F4C@vpn.id2.novell.com>
 <AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
 <4D7DE39302000078000362E6@vpn.id2.novell.com>
 <20110314095534.GB18058@elte.hu>
 <20110314104131.GG6275@bubble.grove.modra.org>
 <AANLkTi=3AiLaw5Gnis8Ha4eRXirk0s-Cnk2zzN12YDpH__45869.1711457961$1300099861$gmane$org@mail.gmail.com>
 <m3oc5eufrk.fsf@redhat.com>
 <AANLkTikOX_9G-kFEOCHJbnTootY4n4EPSounwjDjPiZc@mail.gmail.com>
 <m3fwqpvrjy.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3fwqpvrjy.fsf@redhat.com>
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


* Andreas Schwab <schwab@redhat.com> wrote:

> Pekka Enberg <penberg@kernel.org> writes:
> 
> > Hi Andreas,
> >
> > Pekka Enberg <penberg@kernel.org> writes:
> >>> So what do you suggest that testers who want to, say, build old Linux
> >>> kernel versions with new binutils do?
> >
> > On Mon, Mar 14, 2011 at 1:02 PM, Andreas Schwab <schwab@redhat.com> wrote:
> >> The same that testers have to do in order to build old Linux kernel
> >> versions with current versions of make.
> >
> > Are you saying it's OK to screw over binutils users because GNU Make
> > did that too?
> 
> I'm just telling you the facts.

And you are wrong - latest Make does not break reasonably old kernel builds such as 
v2.6.30.

Latest binutils insta-breaks the build over 130,000 commits, including the latest 
released kernel.

Please change that .size build error to a build warning, to avoid this unnecessary 
collateral damage.

Thanks,

	Ingo
