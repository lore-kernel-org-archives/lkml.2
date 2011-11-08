Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1KHLjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:39:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1KHLjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:39:15 -0500
Date: Tue, 8 Nov 2011 13:39:09 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        Vince Weaver <vince@deater.net>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] perf ABI backwards and forwards compatibility
In-Reply-To: <20111108113150.GA13195@redhat.com>
Message-ID: <alpine.LFD.2.02.1111081336410.18135@tux.localdomain>
References: <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu> <y0mpqh3og3v.fsf@fche.csb> <alpine.LFD.2.02.1111072204370.3082@tux.localdomain> <20111107203514.GG24234@thunk.org> <20111108102235.GA1241@elte.hu>
 <20111108113150.GA13195@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011, Frank Ch. Eigler wrote:
> Almost: they demonstrate that those parts of the ABI that these
> particular perf commands rely on have been impressively compatible.
> Do you have any sort of ABI coverage measurement, to see what
> parts of the ABI these perf commands do not use?

It's pretty obvious that perf ABI is lacking on that department based on 
Vince's comments, isn't it?  There's an easy fix for this too: improve 
"perf test" to cover the cases you're intested in.  While ABI spec would 
be a nice addition, it's not going to make compatibility problems 
magically go away.

 			Pekka
