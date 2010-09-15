Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0IOJ37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:29:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44587 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0IOJ36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:29:58 -0400
Date: Wed, 15 Sep 2010 11:29:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100915092943.GI16593@elte.hu>
References: <20100913172438.37443bf7@basil.nowhere.org>
 <20100913154750.GA26290@redhat.com>
 <20100913185721.59ad9b4d@basil.nowhere.org>
 <20100913175346.GC26290@redhat.com>
 <20100913200707.3b31429e@basil.nowhere.org>
 <20100913182354.GE26290@redhat.com>
 <20100913203654.26724055@basil.nowhere.org>
 <20100913193655.GF26290@redhat.com>
 <20100914122131.GF12425@elte.hu>
 <20100914193449.GA9797@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914193449.GA9797@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2212]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Sep 14, 2010 at 02:21:31PM +0200, Ingo Molnar wrote:
> > 
> ... 
> > The proper approach would be not to add hacks to the NMI code but to 
> > implement southbridge drivers - which would also have NMI callbacks. 
> > These are unchartered waters, but variance in that space is reducing 
> > systematically so it would be worth a shot.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> while there is a conversation about makeing NMI handler robust/modern 
> or whatever, I think the naming Huang has implemented for NMI 
> Stat&Ctrl registers/ports look quite good and convenient (I thought 
> about this times ago when being merging nmi-32/64 code but didn't 
> implemented it properly). So I presume perhaps we could merge this 
> snippets first? Or I miss something on discussion in general?

Yeah, i'm waiting for Don to pick out the good ones and send them to me 
after a bit of testing (he's been driving this topic lately). We can 
obviously make some progress.

Thanks,

	Ingo
