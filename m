Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab1KGM7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:59:16 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64376 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab1KGM7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:59:14 -0500
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
Date: Mon, 7 Nov 2011 14:59:13 +0200
X-Google-Sender-Auth: waxv-Kvk12Xwhh54CDyvHCR6Za8
Message-ID: <CAOJsxLH+2A8+p3ju808BOrfze5yWkTjFX6PRAsPhFO4CWTzkKQ@mail.gmail.com>
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
> Perf was IMHO an overreaction caused by the fact that systemtap and
> oprofile people packaged and released the sources in a way that kernel
> developers didn't like.
>
> I don't think perf should be used as a precendent that now argues that
> any new kernel utility should be moved into the kernel sources.  Does
> it make sense to move all of mount, fsck, login, etc., into the kernel
> sources?  There are far more kernel tools outside of the kernel
> sources than inside the kernel sources.

There's two overlapping questions here:

  (1) Does it make sense to merge the KVM tool to Linux kernel tree?

  (2) Does it make sense to merge userspace tools to the kernel tree?

I'm not trying to use perf to justify merging the KVM tool. However, you
seem to be arguing that it shouldn't be merged because merging
userspace tools in general doesn't make sense. That's why I brought up
the situation with perf.

                        Pekka
