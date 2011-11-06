Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab1KFKHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 05:07:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1KFKHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 05:07:44 -0500
Message-ID: <4EB65C5B.8070709@redhat.com>
Date: Sun, 06 Nov 2011 12:07:23 +0200
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
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
In-Reply-To: <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 12:04 PM, Pekka Enberg wrote:
> Hi Alexander,
>
> On Sun, Nov 6, 2011 at 3:35 AM, Alexander Graf <agraf@suse.de> wrote:
> > On LinuxCon I had a nice chat with Linus on what he thinks kvm-tool
> > would be doing and what he expects from it. Basically he wants a
> > small and simple tool he and other developers can run to try out and
> > see if the kernel they just built actually works.
> >
> > Fortunately, QEMU can do that today already! The only piece that was
> > missing was the "simple" piece of the equation, so here is a script
> > that wraps around QEMU and executes a kernel you just built.
>
> I'm happy to see some real competition for the KVM tool in usability. ;-)
>
> That said, while the script looks really useful for developers,
> wouldn't it make more sense to put it in QEMU to make sure it's kept
> up-to-date and distributions can pick it up too? (And yes, I realize
> the irony here.)

Why would distributions want it?  It's only useful for kernel developers.

-- 
error compiling committee.c: too many arguments to function

