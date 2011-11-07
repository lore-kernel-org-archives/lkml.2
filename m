Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1KGK20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:28:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1KGK2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:28:25 -0500
Message-ID: <4EB7B375.4090904@redhat.com>
Date: Mon, 07 Nov 2011 11:31:17 +0100
From: Kevin Wolf <kwolf@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6AE34.2000907@redhat.com> <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com> <4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org>
In-Reply-To: <20111106183132.GA4500@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2011 19:31, schrieb Ted Ts'o:
> On Sun, Nov 06, 2011 at 11:08:10AM -0600, Anthony Liguori wrote:
>> I'm quite happy with KVM tool and hope they continue working on it.
>> My only real wish is that they wouldn't copy QEMU so much and would
>> try bolder things that are fundamentally different from QEMU.
> 
> My big wish is that they don't try to merge the KVM tool into the
> kernel code.  It's a separate userspace project, and there's no reason
> for it to be bundled with kernel code.  It just makes the kernel
> sources larger. 

In fact, the reverse is true as well: It makes kvm-tool's sources
larger. Instead on just cloning a small repository I need to clone the
whole kernel repository, even though I'm not a kernel developer and
don't intend to touch anything but tools/kvm.

Not too bad for me as I have a kernel repository lying around anyway and
I can share most of the content, but there are people who don't. Still,
having an additional 1.2 GB repository just for ~1 MB in which I'm
really interested doesn't make me too happy. And dealing with a huge
repository also means that even git becomes slower (which means, I had
to turn off some functionality for my shell prompt in this repo, as I
didn't like waiting for much more than a second or two)

Makes it a lot less hackable for me unless you want to restrict the set
of potential developers to Linux kernel developers...

Kevin
