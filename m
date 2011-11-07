Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1KGMpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:45:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab1KGMpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:45:03 -0500
Message-ID: <4EB7D2C0.80201@redhat.com>
Date: Mon, 07 Nov 2011 14:44:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Sasha Levin <levinsasha928@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <4EB7B1A9.9000409@redhat.com> <CA+1xoqfXq++t9YzqDQH60oLDkWhyvEJsC6QWJ1gx8ikQA=eAhQ@mail.gmail.com> <4EB7CE71.50401@redhat.com> <CAOJsxLEMdmWH06Dd+g4SkuG8H9iGwdBMSQYthMYtF9eyC2p9Ew@mail.gmail.com>
In-Reply-To: <CAOJsxLEMdmWH06Dd+g4SkuG8H9iGwdBMSQYthMYtF9eyC2p9Ew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 02:29 PM, Pekka Enberg wrote:
> Hi Avi,
>
> On Mon, Nov 7, 2011 at 2:26 PM, Avi Kivity <avi@redhat.com> wrote:
> >> tools/power was merged in just 2 versions ago, do you think that
> >> merging that was a mistake?
> >
> > Things like tools/power may make sense, most of the code is tied to the
> > kernel interfaces.  tools/kvm is 20k lines and is likely to be 40k+
> > lines or more before it is generally usable.  The proportion of the code
> > that talks to the kernel is quite small.
>
> So what do you think about perf then? The amount of code that talks to
> the kernel is much smaller than that of the KVM tool.

Maybe it's outgrown the kernel repo too.  Certainly something that has
perl and python integration, a TUI, and one day hopefully a GUI, doesn't
really need the kernel sources.

-- 
error compiling committee.c: too many arguments to function

