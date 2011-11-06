Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1KFSFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:05:48 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36803 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1KFSFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:05:46 -0500
MIME-Version: 1.0
In-Reply-To: <E0D7D6BB-AB05-43DA-B679-BB2C3CA43E2C@suse.de>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
	<E0D7D6BB-AB05-43DA-B679-BB2C3CA43E2C@suse.de>
Date: Sun, 6 Nov 2011 20:05:45 +0200
X-Google-Sender-Auth: Dqs9wTjDSndrF_pbG7FpiyWfBwI
Message-ID: <CAOJsxLFCjkAK7Lw4M15G44k11zrcF7tnu9yMbiQYDBNZr+83tg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 7:30 PM, Alexander Graf <agraf@suse.de> wrote:
>> That's pretty much what git submodule would do, isn't it?
>>
>> I really don't see the point in doing that. We want to be part of
>> regular kernel history and release cycle. We want people to be able to
>> see what's going on in our tree to keep us honest and we want to make
>> the barrier of entry as low as possible.
>>
>> It's not just about code, it's as much about culture and development process.
>
> So you're saying that projects that are not living in the kernel tree aren't worthwhile?

Yeah, that's exactly what I'm saying...

> Or are you only trying to bump your oloh stats?

That too!

On Sun, Nov 6, 2011 at 7:30 PM, Alexander Graf <agraf@suse.de> wrote:
> I mean, seriously, git makes it so easy to have a separate tree that
> it almost doesn't make sense not to have one. You're constantly
> working in separate trees yourself because every one of your
> branches is separate. Keeping in sync with the kernel release cycles
> (which I don't think makes any sense for you) should be easy enough
> too by merely releasing in sync with the kernel tree...

We'd be the only subsystem doing that! Why on earth do you think we
want to be the first ones to do that? We don't want to be different,
we want to make the barrier of entry low.

                        Pekka
