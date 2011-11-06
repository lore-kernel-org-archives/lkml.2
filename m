Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1KFM14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 07:27:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45093 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1KFM1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 07:27:55 -0500
MIME-Version: 1.0
In-Reply-To: <4EB67486.1070105@redhat.com>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
Date: Sun, 6 Nov 2011 14:27:54 +0200
X-Google-Sender-Auth: j9y-zhe8TZMFo4HI_BHnmIvwYQU
Message-ID: <CAOJsxLG_AyAimafdKAixzrmzOw-2z6vMraXYOHLyApSP9jKyVw@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>,
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

On Sun, Nov 6, 2011 at 1:50 PM, Avi Kivity <avi@redhat.com> wrote:
> So far, kvm-tool capabilities are a subset of qemu's.  Does it add
> anything beyond a different command-line?

I think "different command line" is a big thing which is why we've
spent so much time on it. But if you mean other end user features, no,
we don't add anything new on the table right now. I think our
userspace networking implementation is better than QEMU's slirp but
that's purely technical thing.

I also don't think we should add new features for their own sake.
Linux virtualization isn't a terribly difficult thing to do thanks to
KVM and virtio drivers. I think most of the big ticket items will be
doing things like improving guest isolation and making guests more
accessible to the host.

                                Pekka
