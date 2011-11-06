Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1KFMOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 07:14:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64154 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1KFMOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 07:14:17 -0500
MIME-Version: 1.0
In-Reply-To: <4EB67486.1070105@redhat.com>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
Date: Sun, 6 Nov 2011 14:14:16 +0200
X-Google-Sender-Auth: kD_CygQEZUDes4HtEsyz1Yl1oQA
Message-ID: <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
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
>> People seem to think the KVM tool is only about solving a specific
>> problem to kernel developers. That's certainly never been my goal as I
>> do lots of userspace programming as well. The end game for me is to
>> replace QEMU/VirtualBox for Linux on Linux virtualization for my day to
>> day purposes.
>
> Maybe it should be in tools/pekka then.  Usually subsystems that want to
> be merged into Linux have broaded audiences though.

I think you completely missed my point.

I'm simply saying that KVM tool was never about solving a narrow
problem Alexander's script is trying to solve. That's why I feel it's
such a pointless exercise.

                        Pekka
