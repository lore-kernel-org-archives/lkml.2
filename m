Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1KGTxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:53:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42837 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1KGTxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:53:30 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
References: <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<4EB6AE34.2000907@redhat.com>
	<CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
	<4EB6BAED.2030400@redhat.com>
	<4EB6BEFA.6000303@codemonkey.ws>
	<20111106183132.GA4500@thunk.org>
	<CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
	<CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
	<20111106231953.GD4500@thunk.org>
	<alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
	<alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
Date: Mon, 7 Nov 2011 21:53:28 +0200
X-Google-Sender-Auth: luQ7rn21r3j8eyTtA5xEavKAtvM
Message-ID: <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Avi Kivity <avi@redhat.com>,
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

On Mon, 7 Nov 2011, Pekka Enberg wrote:
>> I've never heard ABI incompatibility used as an argument for perf. Ingo?

On Mon, Nov 7, 2011 at 7:03 PM, Vince Weaver <vince@deater.net> wrote:
> Never overtly.  They're too clever for that.

If you want me to take you seriously, spare me from the conspiracy theories, OK?

I'm sure perf developers break the ABI sometimes - that happens
elsewhere in the kernel as well. However, Ted claimed that perf
developers use tools/perf as an excuse to break the ABI _on purpose_
which is something I have hard time believing.

Your snarky remarks doesn't really help this discussion either. It's
apparent from the LKML discussions that you're more interested in
arguing with the perf developers rather than helping them.

                        Pekka
