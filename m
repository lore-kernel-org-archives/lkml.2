Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab1KFKMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 05:12:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42898 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1KFKMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 05:12:14 -0500
MIME-Version: 1.0
In-Reply-To: <4EB65C5B.8070709@redhat.com>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
Date: Sun, 6 Nov 2011 12:12:13 +0200
X-Google-Sender-Auth: WX3asvaLIHA2-MqviFBs9z48XAg
Message-ID: <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
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

On Sun, Nov 6, 2011 at 12:07 PM, Avi Kivity <avi@redhat.com> wrote:
>> I'm happy to see some real competition for the KVM tool in usability. ;-)
>>
>> That said, while the script looks really useful for developers,
>> wouldn't it make more sense to put it in QEMU to make sure it's kept
>> up-to-date and distributions can pick it up too? (And yes, I realize
>> the irony here.)
>
> Why would distributions want it?  It's only useful for kernel developers.

It's useful for kernel testers too.

If this is a serious attempt in making QEMU command line suck less on
Linux, I think it makes sense to do this properly instead of adding a
niche script to the kernel tree that's simply going to bit rot over
time.

                        Pekka
