Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1CNMLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:11:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab1CNMLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:11:00 -0400
Date: Mon, 14 Mar 2011 13:10:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Andreas Schwab <schwab@redhat.com>, Jan Beulich <JBeulich@novell.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, binutils@sourceware.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Modra <amodra@gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314121028.GD23257@elte.hu>
References: <20110311165802.GA3508@intel.com>
 <4D7A64670200007800035F4C@vpn.id2.novell.com>
 <AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
 <4D7DE39302000078000362E6@vpn.id2.novell.com>
 <20110314095534.GB18058@elte.hu>
 <20110314104131.GG6275@bubble.grove.modra.org>
 <AANLkTi=3AiLaw5Gnis8Ha4eRXirk0s-Cnk2zzN12YDpH__45869.1711457961$1300099861$gmane$org@mail.gmail.com>
 <m3oc5eufrk.fsf@redhat.com>
 <AANLkTikOX_9G-kFEOCHJbnTootY4n4EPSounwjDjPiZc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikOX_9G-kFEOCHJbnTootY4n4EPSounwjDjPiZc@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> Hi Andreas,
> 
> Pekka Enberg <penberg@kernel.org> writes:
> >> So what do you suggest that testers who want to, say, build old Linux
> >> kernel versions with new binutils do?
> 
> On Mon, Mar 14, 2011 at 1:02 PM, Andreas Schwab <schwab@redhat.com> wrote:
> > The same that testers have to do in order to build old Linux kernel
> > versions with current versions of make.
> 
> Are you saying it's OK to screw over binutils users because GNU Make
> did that too?

The claim is not even true.

While really old Linux versions wont build with fresh versions of Make, something 
like v2.6.30, which is a 2 years old kernel, will build just fine, using latest 
Make.

So lets stop coming up with all the wrong reasons to not fix this problem ...

Thanks,

	Ingo
