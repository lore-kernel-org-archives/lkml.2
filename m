Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1KGUJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:09:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41683 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1KGUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:09:43 -0500
Date: Mon, 7 Nov 2011 22:09:34 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vince@deater.net>,
        "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
In-Reply-To: <y0mpqh3og3v.fsf@fche.csb>
Message-ID: <alpine.LFD.2.02.1111072204370.3082@tux.localdomain>
References: <4EB6AE34.2000907@redhat.com> <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com> <4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu>
 <y0mpqh3og3v.fsf@fche.csb>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Frank Ch. Eigler wrote:
>> The ABI design allows for that kind of flexible extensibility, and
>> it's one of its major advantages.
>>
>> What we *cannot* protect against is you relying on obscure details of
>> the ABI [...]
>
> Is there some documentation that clearly spells out which parts of the
> perf syscall userspace ABI are "obscure" and thus presumably
> changeable?

That's actually something the KVM and virtio folks have done a great job 
with IMHO. Both ABIs are documented pretty extensively and the specs are 
kept up to date.

I guess for perf ABI, "perf test" is the closest thing to a specification 
so if your application is using something that's not covered by it, you 
might be in trouble.

 			Pekka
