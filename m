Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1KGGmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:42:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52791 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1KGGmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:42:11 -0500
Date: Mon, 7 Nov 2011 08:42:01 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: "Ted Ts'o" <tytso@mit.edu>
cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
In-Reply-To: <20111106231953.GD4500@thunk.org>
Message-ID: <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
References: <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6AE34.2000907@redhat.com> <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
 <4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Nov 2011, Ted Ts'o wrote:
> The only excuse I can see is a hope to make random changes to the
> kernel and userspace tools without having to worry about compatibility
> problems, which is an argument I've seen with perf (that you have to
> use the same version of perf as the kernel version, which to me is bad
> software engineering).  And that's why I pointed out that you can't do
> that with KVM, since we have out-of-tree userspace users, namely
> qemu-kvm.

I've never heard ABI incompatibility used as an argument for perf. Ingo?

As for the KVM tool, merging has never been about being able to do ABI 
incompatible changes and never will be. I'm still surprised you even 
brought this up because I've always been one to _complain_ about people 
breaking the ABI - not actually breaking it (at least on purpose).

 			Pekka
