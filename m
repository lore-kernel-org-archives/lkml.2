Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1KGMnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:43:02 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38856 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab1KGMm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:42:58 -0500
MIME-Version: 1.0
In-Reply-To: <20111107122902.GA24685@thunk.org>
References: <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
	<4EB7B1A9.9000409@redhat.com>
	<alpine.LFD.2.02.1111071333350.2815@tux.localdomain>
	<4EB7CA52.5050409@redhat.com>
	<20111107122902.GA24685@thunk.org>
Date: Mon, 7 Nov 2011 14:42:57 +0200
X-Google-Sender-Auth: 5xpRcIRjhfhYzEAO9EsKKVYoweM
Message-ID: <CAOJsxLGuRtWHbOugqHoxCNDmCrtiLFh7xMo8BVGNprG3GoanOQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Gerd Hoffmann <kraxel@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Pekka Enberg <penberg@kernel.org>, Alexander Graf <agraf@suse.de>,
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

Hi Ted,

On Mon, Nov 7, 2011 at 2:29 PM, Ted Ts'o <tytso@mit.edu> wrote:
> And the same problems will exist with kvm-tool.  What if you need to
> release a new version of kvm-tool?  Does that mean that you have to
> release a new set of kernel binaries?  It's a mess, and there's a
> reason why we don't have glibc, e2fsprogs, xfsprogs, util-linux-ng,
> etc., all packaged into the kernel sources.

If we need to release a new version, patches would go through the
-stable tree just like with any other subsystem.

On Mon, Nov 7, 2011 at 2:29 PM, Ted Ts'o <tytso@mit.edu> wrote:
> Because it's a stupid, idiotic thing to do.

The discussion is turning into whether or not linux/tools makes sense
or not. I wish you guys would have had it before perf was merged to
the tree.

                        Pekka
