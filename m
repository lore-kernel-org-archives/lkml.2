Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1KGUDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:03:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1KGUDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:03:49 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Vince Weaver <vince@deater.net>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?us-ascii?Q?=3D=3Fiso-8859-1=3FQ=3FAm=3DE9rico=3F=3D?= Wang 
	<xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <4EB6AE34.2000907@redhat.com>
	<CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
	<4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws>
	<20111106183132.GA4500@thunk.org>
	<CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
	<CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
	<20111106231953.GD4500@thunk.org>
	<alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
	<alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
	<20111107175942.GA9395@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 07 Nov 2011 15:03:00 -0500
In-Reply-To: <20111107175942.GA9395@elte.hu> (Ingo Molnar's message of "Mon, 7 Nov 2011 18:59:42 +0100")
Message-ID: <y0mpqh3og3v.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> [...]
>> It's problem enough that there's no way to know what version of the 
>> perf_event abi you are running against and we have to guess based 
>> on kernel version.  This gets "fun" because all of the vendors have 
>> backported seemingly random chunks of perf_event code to their 
>> older kernels.
>
> The ABI design allows for that kind of flexible extensibility, and 
> it's one of its major advantages.
>
> What we *cannot* protect against is you relying on obscure details of 
> the ABI [...]

Is there some documentation that clearly spells out which parts of the
perf syscall userspace ABI are "obscure" and thus presumably
changeable?

> [...]  The usual ABI rules also apply: we'll revert everything that
> breaks the ABI - but for that you need to report it *in time* [...]

If the ABI is so great in its flexible extensibility, how come it
can't be flexibly extended without having to passing the burden of
compatibility testing & reversion-yawping to someone else?


- FChE
