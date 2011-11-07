Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1KGGpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:45:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41895 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1KGGpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:45:42 -0500
Date: Mon, 7 Nov 2011 08:45:32 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: Anthony Liguori <anthony@codemonkey.ws>
cc: Pekka Enberg <penberg@kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        Avi Kivity <avi@redhat.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
In-Reply-To: <4EB7368D.1080003@codemonkey.ws>
Message-ID: <alpine.LFD.2.02.1111070842150.1823@tux.localdomain>
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com>
 <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6AE34.2000907@redhat.com> <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com> <4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws>
 <CAOJsxLFApM9D_29h+qbU+npJgjKbOVvMBvftvHpmWwSqzE=Pkw@mail.gmail.com> <4EB7368D.1080003@codemonkey.ws>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

On Sun, 6 Nov 2011, Anthony Liguori wrote:
> - Drop SDL/VNC.  Make a proper Cairo GUI with a full blown GTK interface. 
> Don't rely on virt-manager for this.  Not that I have anything against 
> virt-manager but there are many layers between you and the end GUI if you go 
> that route.

Funny that you should mention this. It was actually what I started out 
with. I went for SDL because it was a low-hanging fruit after the VNC 
patches which I didn't do myself.

However, it was never figured out if there was going to be a virtio 
transport for GPU commands:

http://lwn.net/Articles/408831/

On Sun, 6 Nov 2011, Anthony Liguori wrote:
> - Sandbox the device model from day #1.  The size of the Linux kernel 
> interface is pretty huge and as a hypervisor, it's the biggest place for 
> improvement from a security perspective.  We're going to do sandboxing in 
> QEMU, but it's going to be difficult.  It would be much easier for you given 
> where you're at.

Completely agreed. I think Sasha is actually starting to work on this. See 
the "Secure KVM" thread on kvm@.

 			Pekka
