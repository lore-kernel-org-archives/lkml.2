Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1KFR2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:28:05 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46476 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1KFR2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:28:03 -0500
MIME-Version: 1.0
In-Reply-To: <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
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
Date: Sun, 6 Nov 2011 19:28:02 +0200
X-Google-Sender-Auth: ZKagxNZLALsknwVHNx1JcGUpf9w
Message-ID: <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
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

On Sun, Nov 6, 2011 at 7:15 PM, Alexander Graf <agraf@suse.de> wrote:
>> The difference here is that although I feel Alex's script is a
>> pointless project, I'm in no way opposed to merging it in the tree if
>> people use it and it solves their problem. Some people seem to be
>> violently opposed to merging the KVM tool and I'm having difficult
>> time understanding why that is.
>
> It's a matter of size and scope. Write a shell script that clones, builds and
> executes KVM Tool and throw it in testing/tools/ and I'll happily ack it!

That's pretty much what git submodule would do, isn't it?

I really don't see the point in doing that. We want to be part of
regular kernel history and release cycle. We want people to be able to
see what's going on in our tree to keep us honest and we want to make
the barrier of entry as low as possible.

It's not just about code, it's as much about culture and development process.

                                Pekka
