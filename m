Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab1KFM1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 07:27:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1KFM1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 07:27:21 -0500
Message-ID: <4EB67D17.7000701@redhat.com>
Date: Sun, 06 Nov 2011 14:27:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
In-Reply-To: <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 02:14 PM, Pekka Enberg wrote:
> On Sun, Nov 6, 2011 at 1:50 PM, Avi Kivity <avi@redhat.com> wrote:
> >> People seem to think the KVM tool is only about solving a specific
> >> problem to kernel developers. That's certainly never been my goal as I
> >> do lots of userspace programming as well. The end game for me is to
> >> replace QEMU/VirtualBox for Linux on Linux virtualization for my day to
> >> day purposes.
> >
> > Maybe it should be in tools/pekka then.  Usually subsystems that want to
> > be merged into Linux have broaded audiences though.
>
> I think you completely missed my point.
>
> I'm simply saying that KVM tool was never about solving a narrow
> problem Alexander's script is trying to solve. That's why I feel it's
> such a pointless exercise.

But from your description, you're trying to solve just another narrow
problem:

"The end game for me is to replace QEMU/VirtualBox for Linux on Linux
virtualization for my day to day purposes. "

We rarely merge a subsystem to solve one person's problem (esp. when it
is defined as "replace another freely available project", even if you
dislike its command line syntax).

-- 
error compiling committee.c: too many arguments to function

