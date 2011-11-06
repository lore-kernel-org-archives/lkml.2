Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1KFKE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 05:04:58 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38808 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1KFKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 05:04:56 -0500
MIME-Version: 1.0
In-Reply-To: <1320543320-32728-1-git-send-email-agraf@suse.de>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
Date: Sun, 6 Nov 2011 12:04:55 +0200
X-Google-Sender-Auth: dArPWzvX4IDmB8fMJ8AayK2Ikrs
Message-ID: <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Alexander Graf <agraf@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Sun, Nov 6, 2011 at 3:35 AM, Alexander Graf <agraf@suse.de> wrote:
> On LinuxCon I had a nice chat with Linus on what he thinks kvm-tool
> would be doing and what he expects from it. Basically he wants a
> small and simple tool he and other developers can run to try out and
> see if the kernel they just built actually works.
>
> Fortunately, QEMU can do that today already! The only piece that was
> missing was the "simple" piece of the equation, so here is a script
> that wraps around QEMU and executes a kernel you just built.

I'm happy to see some real competition for the KVM tool in usability. ;-)

That said, while the script looks really useful for developers,
wouldn't it make more sense to put it in QEMU to make sure it's kept
up-to-date and distributions can pick it up too? (And yes, I realize
the irony here.)

                        Pekka
