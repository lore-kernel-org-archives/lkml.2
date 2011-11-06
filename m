Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1KFTOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:14:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53337 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1KFTO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:14:29 -0500
Message-ID: <4EB6DC92.6010105@redhat.com>
Date: Sun, 06 Nov 2011 20:14:26 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.comp.emulators.qemu,gmane.comp.emulators.kvm.devel,gmane.linux.kernel
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
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <E0D7D6BB-AB05-43DA-B679-BB2C3CA43E2C@suse.de> <CAOJsxLFCjkAK7Lw4M15G44k11zrcF7tnu9yMbiQYDBNZr+83tg@mail.gmail.com>
In-Reply-To: <CAOJsxLFCjkAK7Lw4M15G44k11zrcF7tnu9yMbiQYDBNZr+83tg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 07:05 PM, Pekka Enberg wrote:
>> I mean, seriously, git makes it so easy to have a separate tree that
>> >  it almost doesn't make sense not to have one. You're constantly
>> >  working in separate trees yourself because every one of your
>> >  branches is separate. Keeping in sync with the kernel release cycles
>> >  (which I don't think makes any sense for you) should be easy enough
>> >  too by merely releasing in sync with the kernel tree...
> We'd be the only subsystem doing that!

GStreamer (V4L), RTSAdmin (LIO target), sg3_utils, trousers all are out 
of tree, and nobody of their authors is even thinking of doing all this 
brouhaha to get merged into Linus's tree.

Paolo
