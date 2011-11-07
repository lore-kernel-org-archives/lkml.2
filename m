Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1KGLfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:35:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1KGLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:35:08 -0500
Date: Mon, 7 Nov 2011 13:34:51 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: Gerd Hoffmann <kraxel@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>, Alexander Graf <agraf@suse.de>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
In-Reply-To: <4EB7B1A9.9000409@redhat.com>
Message-ID: <alpine.LFD.2.02.1111071333350.2815@tux.localdomain>
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com>
 <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <4EB7B1A9.9000409@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Gerd Hoffmann wrote:
>> It's not just about code, it's as much about culture and development process.
>
> Indeed.  The BSDs have both kernel and the base system in a single
> repository.  There are probably good reasons for (and against) it.
>
> In Linux we don't have that culture.  No tool (except perf) lives in the
> kernel repo.  I fail to see why kvm-tool is that much different from
> udev, util-linux, iproute, filesystem tools, that it should be included.

You seem to think perf is an exception - I think it's going to be the 
future norm for userspace components that are very close to the kernel. 
That's in fact what Ingo was arguing for when he suggested QEMU to be 
merged to the kernel tree.

 			Pekka
