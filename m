Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1KFQat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:30:49 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57542 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab1KFQas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:30:48 -0500
MIME-Version: 1.0
In-Reply-To: <4EB6B385.4070804@web.de>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<4EB6B385.4070804@web.de>
Date: Sun, 6 Nov 2011 18:30:47 +0200
X-Google-Sender-Auth: mhvAXeStIP7tqwvQ2ixQJfOGjIk
Message-ID: <CAOJsxLH5Vgk7tyr=RAEc=S2JhZ7n2JxOiUL9L91P_Bey+AuFUA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Sun, Nov 6, 2011 at 6:19 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
> "Usable" - I've tried kvm-tool several times and still (today) fail to
> get a standard SUSE image (with a kernel I have to compile and provide
> separately...) up and running *). Likely a user mistake, but none that
> is very obvious. At least to me.
>
> In contrast, you can throw arbitrary Linux distros in various forms at
> QEMU, and it will catch and run them. For me, already this is more usable.
>
> *) kvm run -m 1000 -d OpenSuse11-4_64.img arch/x86/boot/bzImage \
>        -p root=/dev/vda2
> ...
> [    1.772791] mousedev: PS/2 mouse device common for all mice
> [    1.774603] cpuidle: using governor ladder
> [    1.775490] cpuidle: using governor menu
> [    1.776865] input: AT Raw Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input0
> [    1.778609] TCP cubic registered
> [    1.779456] Installing 9P2000 support
> [    1.782390] Registering the dns_resolver key type
> [    1.794323] registered taskstats version 1
>
> ...and here the boot just stops, guest apparently waits for something

Can you please share your kernel .config with me and I'll take a look
at it. We now have a "make kvmconfig" makefile target for enabling all
the necessary config options for guest kernels. I don't think any of
us developers are using SUSE so it can surely be a KVM tool bug as
well.

                                Pekka
