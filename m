Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1KIIa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:30:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50141 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab1KIIa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:30:28 -0500
Date: Wed, 9 Nov 2011 09:28:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ted Ts'o" <tytso@mit.edu>, Anca Emanuel <anca.emanuel@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111109082837.GB11473@elte.hu>
References: <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125509.GB1022@elte.hu>
 <20111108163331.GJ24234@thunk.org>
 <CAJL_dMtO9V40exAkThBObTUuWXkmNdNKaaNvC4-ndTRpz+dxsQ@mail.gmail.com>
 <20111108192413.GL24234@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108192413.GL24234@thunk.org>
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


* Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Nov 08, 2011 at 07:14:57PM +0200, Anca Emanuel wrote:

> > @Ten Ts'o: you are sponsored by something like microsoft (joking) 
> > ? Stop trolling. If you are not familiar with perf, or other 
> > tools, save your time and do some useful things.
> 
> I am quite familiar with perf.  A disagreement with how things are 
> done is not trolling.

Anca, Ted is not trolling me in any fashion. He is a (very 
successful) tool space and kernel developer and his opinion and 
experience about how tools should interact with the kernel project is 
of utmost importance.

Clearly Ted thinks that filesystem tools should stay separate from 
the kernel repo. I agree with him that the case for filesystem tool 
integration is weaker than for deeply kernel integrated tools such as 
perf or kvm and calling him a troll is not a way to settle that 
honest disagreement in any case.

Thanks,

	Ingo
