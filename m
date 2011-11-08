Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab1KHObE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:31:04 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64028 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab1KHObB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:31:01 -0500
MIME-Version: 1.0
In-Reply-To: <20111108132935.GE3322@nb.net.home>
References: <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
	<4EB7B1A9.9000409@redhat.com>
	<alpine.LFD.2.02.1111071333350.2815@tux.localdomain>
	<4EB7CA52.5050409@redhat.com>
	<20111107122902.GA24685@thunk.org>
	<CAOJsxLGuRtWHbOugqHoxCNDmCrtiLFh7xMo8BVGNprG3GoanOQ@mail.gmail.com>
	<20111107124757.GC24685@thunk.org>
	<CAOJsxLGeyvv93YT244nMy59wKS8hkR1_NE6+6zEvzJiR0r2zRQ@mail.gmail.com>
	<20111108132935.GE3322@nb.net.home>
Date: Tue, 8 Nov 2011 16:30:59 +0200
X-Google-Sender-Auth: s0hd8wv9YLc4l-PueZk6D4DDmuE
Message-ID: <CAOJsxLFqe9TpyOs_qYftxRTpfOVPcV=X=MOUBSL4UTCDa5jGvQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Karel Zak <kzak@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Gerd Hoffmann <kraxel@redhat.com>,
        Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 3:29 PM, Karel Zak <kzak@redhat.com> wrote:
>> I don't know if it makes sense to merge the tools you've mentioned above.
>> My gut feeling is that it's probably not reasonable - there's already a
>> community working on it with their own development process and coding
>> style. I don't think there's a simple answer to this but I don't agree with
>> your rather extreme position that all userspace tools should be kept out
>> of the kernel tree.
>
> Ted's position is not extreme. He follows the simple and exactly defined
> border between userspace and kernel. The native userspace feature is
> variability and substitutability.

It's an extreme position because he's arguing that we should only have
kernel code in the tree or we need open up to all userspace code.

                        Pekka
