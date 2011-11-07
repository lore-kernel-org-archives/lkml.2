Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1KGL5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:57:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab1KGL5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:57:22 -0500
Message-ID: <4EB7C82A.6020905@redhat.com>
Date: Mon, 07 Nov 2011 12:59:38 +0100
From: Kevin Wolf <kwolf@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
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
References: <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6AE34.2000907@redhat.com> <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com> <4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org> <4EB7B375.4090904@redhat.com> <alpine.LFD.2.02.1111071335140.2815@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1111071335140.2815@tux.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.11.2011 12:38, schrieb Pekka Enberg:
> On Mon, 7 Nov 2011, Kevin Wolf wrote:
>> Makes it a lot less hackable for me unless you want to restrict the set
>> of potential developers to Linux kernel developers...
> 
> We're not restricting potential developers to Linux kernel folks. We're 
> making it easy for them because we believe that the KVM tool is a 
> userspace component that requires the kind of low-level knowledge Linux 
> kernel developers have.
> 
> I think you're looking at the KVM tool with your QEMU glasses on without 
> realizing that there's no point in comparing the two: we only support 
> Linux on Linux and we avoid hardware emulation as much as possible. So 
> what makes sense for QEMU, doesn't necessarily translate to the KVM tool 
> project.

I'm not comparing anything. I'm not even referring to the virtualization
functionality of it. It could be doing anything else and it wouldn't
make a difference.

For KVM tool I am not much more than a mere user. Trying it out was
tedious for me, as it is for anyone else who isn't a kernel developer.
That's all I'm saying.

Making things easier for some kernel developers but ignoring that at the
same time it makes things harder for users I consider a not so clever
move. Just wanted to point that out; feel free to ignore it, your
priorities are probably different.

Kevin
