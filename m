Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1KFTLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:11:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53855 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1KFTLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:11:05 -0500
Message-ID: <4EB6DBC6.2010404@redhat.com>
Date: Sun, 06 Nov 2011 20:11:02 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Alexander Graf <agraf@suse.de>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Blue Swirl <blauwirbel@gmail.com>, Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
In-Reply-To: <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 06:28 PM, Pekka Enberg wrote:
> On Sun, Nov 6, 2011 at 7:15 PM, Alexander Graf<agraf@suse.de>  wrote:
>>> The difference here is that although I feel Alex's script is a
>>> pointless project, I'm in no way opposed to merging it in the tree if
>>> people use it and it solves their problem. Some people seem to be
>>> violently opposed to merging the KVM tool and I'm having difficult
>>> time understanding why that is.
>>
>> It's a matter of size and scope. Write a shell script that clones, builds and
>> executes KVM Tool and throw it in testing/tools/ and I'll happily ack it!
>
> That's pretty much what git submodule would do, isn't it?

Absolutely not.  It would always fetch HEAD from the KVM tool repo.  A 
submodule ties each supermodule commit to a particular submodule commit.

> I really don't see the point in doing that. We want to be part of
> regular kernel history and release cycle.

But I'm pretty certain that, when testing 3.2 with KVM tool in a couple 
of years, I want all the shining new features you added in this time; I 
don't want the old end-2011 code.  Same if I'm bisecting kernels, I 
don't want to build KVM tool once per bisection cycle, do I?

Paolo
