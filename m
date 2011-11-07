Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1KGM0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:26:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1KGM0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:26:49 -0500
Message-ID: <4EB7CE71.50401@redhat.com>
Date: Mon, 07 Nov 2011 14:26:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Gerd Hoffmann <kraxel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <4EB7B1A9.9000409@redhat.com> <CA+1xoqfXq++t9YzqDQH60oLDkWhyvEJsC6QWJ1gx8ikQA=eAhQ@mail.gmail.com>
In-Reply-To: <CA+1xoqfXq++t9YzqDQH60oLDkWhyvEJsC6QWJ1gx8ikQA=eAhQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 12:30 PM, Sasha Levin wrote:
> On Mon, Nov 7, 2011 at 12:23 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> >  Hi,
> >
> >> It's not just about code, it's as much about culture and development process.
> >
> > Indeed.  The BSDs have both kernel and the base system in a single
> > repository.  There are probably good reasons for (and against) it.
> >
> > In Linux we don't have that culture.  No tool (except perf) lives in the
> > kernel repo.  I fail to see why kvm-tool is that much different from
> > udev, util-linux, iproute, filesystem tools, that it should be included.
>
> tools/power was merged in just 2 versions ago, do you think that
> merging that was a mistake?

Things like tools/power may make sense, most of the code is tied to the
kernel interfaces.  tools/kvm is 20k lines and is likely to be 40k+
lines or more before it is generally usable.  The proportion of the code
that talks to the kernel is quite small.

-- 
error compiling committee.c: too many arguments to function

