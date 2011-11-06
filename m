Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1KFUbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 15:31:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61731 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFUbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 15:31:17 -0500
MIME-Version: 1.0
In-Reply-To: <4EB6E798.3060000@redhat.com>
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
	<4EB6DBC6.2010404@redhat.com>
	<CAOJsxLGzMqQDwfm8C-6g8SCapEmGs7uUPq+SuL946yg=anV85g@mail.gmail.com>
	<4EB6E798.3060000@redhat.com>
Date: Sun, 6 Nov 2011 22:31:16 +0200
X-Google-Sender-Auth: YmUU8R4DPUFeizkqv6ldkIpyCyc
Message-ID: <CAOJsxLEHwUiZYnHhUZ2MD3Us8NcHi_0OiXE5o5+kFCsNBtkU0g@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.de>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Blue Swirl <blauwirbel@gmail.com>, Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 10:01 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Nothing, but I'm just giving you *strong* hints that a submodule or a merged
> tool is the wrong solution, and the histories of kernel and tool should be
> kept separate.

And btw, I don't really understand what you're trying to accomplish
with this line of reasoning. We've tried both separate and shared
repository and the latter is much better from development point of
view.

This is not some random userspace project that uses the kernel system
calls. It's a hypervisor that implements virtio drivers, serial
emulation, and mini-BIOS. It's very close to the kernel which is why
it's such a good fit with the kernel tree.

I'd actually be willing to argue that from purely technical point of
view, KVM tool makes much more sense to have in the kernel tree than
perf does.

                                Pekka
