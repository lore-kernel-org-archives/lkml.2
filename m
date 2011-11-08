Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1KHNJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:09:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab1KHNJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:09:16 -0500
Date: Tue, 8 Nov 2011 11:08:25 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vince Weaver <vince@deater.net>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to
	test kernels
Message-ID: <20111108130825.GB14272@ghostprotocols.net>
References: <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu> <alpine.DEB.2.02.1111072358190.8884@pianoman.cluster.toy> <20111108120755.GB571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108120755.GB571@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 08, 2011 at 01:07:55PM +0100, Ingo Molnar escreveu:
> * Vince Weaver <vince@deater.net> wrote:
> > as mentioned before I have my own perf_event test suite with 20+ tests.
> >   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html
 
> That should probably be moved into perf test. Arnaldo, any 
> objections?

I'd gladly take patches, I even have in my TODO list for me to volunteer
time to do that at some point.

If somebody else than me or Vince wants to do that... Assuming there is
no licensing problem and Vince doesn't objects for that to be done.

I know that at least the QE team at Red Hat uses it and I hope other QE
teams do it.

- Arnaldo
