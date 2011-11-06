Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1KFSy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:54:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50524 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab1KFSyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:54:24 -0500
MIME-Version: 1.0
In-Reply-To: <20111106183132.GA4500@thunk.org>
References: <4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<4EB6AE34.2000907@redhat.com>
	<CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
	<4EB6BAED.2030400@redhat.com>
	<4EB6BEFA.6000303@codemonkey.ws>
	<20111106183132.GA4500@thunk.org>
Date: Sun, 6 Nov 2011 20:54:24 +0200
X-Google-Sender-Auth: 8VZrp9foEH_XaXILC5ardrJV-FI
Message-ID: <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@kernel.org>,
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

On Sun, Nov 06, 2011 at 11:08:10AM -0600, Anthony Liguori wrote:
>> I'm quite happy with KVM tool and hope they continue working on it.
>> My only real wish is that they wouldn't copy QEMU so much and would
>> try bolder things that are fundamentally different from QEMU.

On Sun, Nov 6, 2011 at 8:31 PM, Ted Ts'o <tytso@mit.edu> wrote:
> My big wish is that they don't try to merge the KVM tool into the
> kernel code.  It's a separate userspace project, and there's no reason
> for it to be bundled with kernel code.  It just makes the kernel
> sources larger.  The mere fact that qemu-kvm exists means that the KVM
> interface has to remain backward compatible; it *is* an ABI.
>
> So integrating kvm-tool into the kernel isn't going to work as a free
> pass to make non-backwards compatible changes to the KVM user/kernel
> interface.  Given that, why bloat the kernel source tree size?

Ted, I'm confused. Making backwards incompatible ABI changes has never
been on the table. Why are you bringing it up?

                        Pekka
