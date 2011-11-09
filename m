Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1KIGEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:04:30 -0500
Received: from smtpauth03.mfg.siteprotect.com ([64.26.60.137]:42080 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab1KIGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:04:28 -0500
Date: Wed, 9 Nov 2011 01:04:16 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
In-Reply-To: <20111108130825.GB14272@ghostprotocols.net>
Message-ID: <alpine.DEB.2.02.1111090100450.718@pianoman.cluster.toy>
References: <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu> <alpine.DEB.2.02.1111072358190.8884@pianoman.cluster.toy> <20111108120755.GB571@elte.hu>
 <20111108130825.GB14272@ghostprotocols.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011, Arnaldo Carvalho de Melo wrote:

> Em Tue, Nov 08, 2011 at 01:07:55PM +0100, Ingo Molnar escreveu:
> > * Vince Weaver <vince@deater.net> wrote:
> > > as mentioned before I have my own perf_event test suite with 20+ tests.
> > >   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html
>  
> > That should probably be moved into perf test. Arnaldo, any 
> > objections?
> 
> I'd gladly take patches, I even have in my TODO list for me to volunteer
> time to do that at some point.
> 
> If somebody else than me or Vince wants to do that... Assuming there is
> no licensing problem and Vince doesn't objects for that to be done.

I have no objections, though I don't really have time right now to do the 
work myself.

The test code is licensed dual GPLv2/BSD.  I should stick that in the 
package somewhere if I haven't already.

My testcases mostly are testing things necessary for proper PAPI 
functionality and are by no means complete.  There are huge
areas of perf_event functionality that are not well tested, especially
the overflow code.

Vince
