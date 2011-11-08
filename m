Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1KHMRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:17:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab1KHMRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:17:09 -0500
Date: Tue, 8 Nov 2011 13:15:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
        Vince Weaver <vince@deater.net>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] perf ABI backwards and forwards compatibility
Message-ID: <20111108121501.GA1022@elte.hu>
References: <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <20111107175942.GA9395@elte.hu>
 <y0mpqh3og3v.fsf@fche.csb>
 <alpine.LFD.2.02.1111072204370.3082@tux.localdomain>
 <20111107203514.GG24234@thunk.org>
 <20111108102235.GA1241@elte.hu>
 <20111108113150.GA13195@redhat.com>
 <alpine.LFD.2.02.1111081336410.18135@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111081336410.18135@tux.localdomain>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> [...] There's an easy fix for this too: improve "perf test" to 
> cover the cases you're intested in. While ABI spec would be a nice 
> addition, it's not going to make compatibility problems magically 
> go away.

Yes, exactly - 'perf test' has been written with that exact purpose. 
In practice 'perf' will cover almost all parts of the ABI.

The one notable thing that isnt being tested in a natural way is the 
'group of events' abstraction - which, ironically, has been added on 
the perfmon guys' insistence. No app beyond the PAPI self-test makes 
actual use of it though, which results in an obvious lack of testing.

Vince: the code is in tools/perf/builtin-test.c and our offer still 
stands, feel free to extend it. Maybe there's some other volunteer 
willing to do that?

Thanks,

	Ingo
