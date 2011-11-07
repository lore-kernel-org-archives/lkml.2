Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1KGNMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:12:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65379 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1KGNM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:12:29 -0500
MIME-Version: 1.0
In-Reply-To: <20111107124757.GC24685@thunk.org>
References: <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
	<4EB7B1A9.9000409@redhat.com>
	<alpine.LFD.2.02.1111071333350.2815@tux.localdomain>
	<4EB7CA52.5050409@redhat.com>
	<20111107122902.GA24685@thunk.org>
	<CAOJsxLGuRtWHbOugqHoxCNDmCrtiLFh7xMo8BVGNprG3GoanOQ@mail.gmail.com>
	<20111107124757.GC24685@thunk.org>
Date: Mon, 7 Nov 2011 15:12:28 +0200
X-Google-Sender-Auth: nZcwRMgAvmVrAWBJ8Xkl5YjfceA
Message-ID: <CAOJsxLGeyvv93YT244nMy59wKS8hkR1_NE6+6zEvzJiR0r2zRQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Alexander Graf <agraf@suse.de>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 2:47 PM, Ted Ts'o <tytso@mit.edu> wrote:
> I don't think perf should be used as a precendent that now argues that
> any new kernel utility should be moved into the kernel sources.  Does
> it make sense to move all of mount, fsck, login, etc., into the kernel
> sources?  There are far more kernel tools outside of the kernel
> sources than inside the kernel sources.

You seem to think that the KVM tool was developed in isolation and we
simply copied the code to tools/kvm for the pull request. That's simply
not true. We've done a lot of work to make the code feel like kernel code
from locking primitive APIs to serial console emulation register names.
We really consider KVM tool to be a new Linux subsystem. It's the long
lost cousin or bastard child of KVM, depending on who you ask.

I don't know if it makes sense to merge the tools you've mentioned above.
My gut feeling is that it's probably not reasonable - there's already a
community working on it with their own development process and coding
style. I don't think there's a simple answer to this but I don't agree with
your rather extreme position that all userspace tools should be kept out
of the kernel tree.

                        Pekka
