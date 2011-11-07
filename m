Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1KGLos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:44:48 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33402 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1KGLor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:44:47 -0500
MIME-Version: 1.0
In-Reply-To: <4EB7BACA.70006@redhat.com>
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
	<4EB7B1A9.9000409@redhat.com>
	<CA+1xoqfXq++t9YzqDQH60oLDkWhyvEJsC6QWJ1gx8ikQA=eAhQ@mail.gmail.com>
	<4EB7BACA.70006@redhat.com>
Date: Mon, 7 Nov 2011 13:44:46 +0200
X-Google-Sender-Auth: UieqlXBKfBnz2wpnCNR9CiF1Q04
Message-ID: <CAOJsxLGFjfQwGJjcCnj_0dos=_BM_5AaZ6NkMEbYDGVgPaHOJA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 1:02 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Indeed I do not see any advantage, since all the interfaces they use are
> stable anyway (sysfs, msr.ko).
>
> If they had gone in x86info, for example, my distro (F16, not exactly
> conservative) would have likely picked those tools up already, but it
> didn't.

Distributing userspace tools in the kernel tree is a relatively new
concept so it's not at all surprising distributions don't pick them up
as quickly. That doesn't mean it's a fundamentally flawed approach,
though.

Also, I'm mostly interested in defending the KVM tool, so I'd prefer
not to argue whether or not carrying userspace code in the kernel tree
makes sense or not. The fact is that Linux is already doing it and I
think the only relevant question is whether or not the KVM tool
qualifies. I obviously think the answer is yes.

                               Pekka
