Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab1CIJ1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:27:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778Ab1CIJ1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:27:21 -0500
Date: Wed, 9 Mar 2011 10:27:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: UV broadcast assist unit base destination node id
Message-ID: <20110309092715.GB25004@elte.hu>
References: <E1Pwevz-0003JE-3g@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Pwevz-0003JE-3g@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> The BAU's initialization of the broadcast description header is lacking
> the coherence domain (high bits) in the nasid.  This causes a catastrophic
> system failure when running on a system with multiple coherence domains. 
> 
> Diffed against 2.6.32.12

Please send a version against the latest x86 tree:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
