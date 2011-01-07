Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1AGM5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:57:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab1AGM5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:57:38 -0500
Date: Fri, 7 Jan 2011 13:57:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
Message-ID: <20110107125722.GA23185@elte.hu>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
 <4D26D3FD020000780002AED9@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com>
 <4D26F3AE020000780002AF5D@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D26F3AE020000780002AF5D@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 07.01.11 at 10:58, David Rientjes <rientjes@google.com> wrote:
> > On Fri, 7 Jan 2011, Jan Beulich wrote:
> > 
> >> However, the problem my patch addresses has been long standing
> >> (I noted it with our .32 based kernel, but according to my looking at
> >> the code it would go back to at least .27), so I'd like to ask for it to
> >> be merged independently (and I should probably have copied stable
> >> too), unless (quite unlikely) Tejun's merge is intended to also be
> >> applied to stable kernels.
> >> 
> > 
> > I don't think this should be targeted to -stable since it's not a bugfix; 
> > this is adding a feature that allows you to disable acpi parsing of the 
> > SRAT on i386.
> 
> How is this not a bug fix if it allows a system to boot that previously
> didn't?

btw., that's an absolutely key piece of information that REALLY should have been 
included in the changelog of the first patch. It is more important than all of the 
changelog.

Thanks,

	Ingo
