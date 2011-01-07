Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1AGPNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:13:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42082 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab1AGPNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:13:08 -0500
Date: Fri, 7 Jan 2011 16:12:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
Message-ID: <20110107151254.GA418@elte.hu>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
 <4D26D3FD020000780002AED9@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com>
 <4D26F3AE020000780002AF5D@vpn.id2.novell.com>
 <20110107125722.GA23185@elte.hu>
 <4D272413020000780002B009@vpn.id2.novell.com>
 <20110107142203.GA12773@elte.hu>
 <4D2730BE020000780002B040@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2730BE020000780002B040@vpn.id2.novell.com>
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

> >>> On 07.01.11 at 15:22, Ingo Molnar <mingo@elte.hu> wrote:
> > Your -stable comment above made it appear to me as if you knew about a 
> > specific 
> > system that crashed this way? As long as it's only theoretical i'm not sure 
> > it 
> > warrants a -stable backport.
> 
> Yes, I do have a system affected (which made me craft the patch
> in the first place).

In that case it's very useful to start the commit with:

  System XYZ crashes during bootup due to a bug in numa= command line option 
  handling.

That will also cause me to add an immediate -stable backport tag from me, even if 
you dont add it. Keeping it all optional and theoretical with 'it may crash' wording 
just hides the essential piece of information that there's a real system affected by 
the bug.

Thanks,

	Ingo
