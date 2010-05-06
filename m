Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab0EFKCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:02:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58416 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab0EFKB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:01:56 -0400
Date: Thu, 6 May 2010 12:01:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: fix fake apicid to node mapping for numa emulation
Message-ID: <20100506100147.GA19843@elte.hu>
References: <alpine.DEB.2.00.1005041659400.13683@chino.kir.corp.google.com>
 <20100506070732.GA32002@elte.hu>
 <alpine.DEB.2.00.1005060222560.19473@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005060222560.19473@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> On Thu, 6 May 2010, Ingo Molnar wrote:
> 
> > > apicids must be mapped to the lowest node ids to maintain generic kernel use 
> > > of functions such as cpu_to_node() that determine device affinity.
> > > 
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > > ---
> > >  Third resend of the same patch.
> > > 
> > >  arch/x86/mm/srat_64.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > There's no info in the changelog about what negative effects this bug had when 
> > it was found, on what hardware it occured, and what the general urgency of the 
> > patch is.
> > 
> 
> Ah, true.  Given the relative obscurity of using NUMA emulation to being 
> with, it would probably benefit from being even more verbose as well.  
> I'll rewrite the changelog and reply to this message with it.

Applied to tip:x86/urgent, thanks David!

	Ingo
