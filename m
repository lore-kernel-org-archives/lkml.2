Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1KINkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 08:40:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39500 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1KINkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 08:40:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111108093225.GB32533@elte.hu>
References: <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
	<CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
	<20111106231953.GD4500@thunk.org>
	<alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
	<alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
	<CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
	<20111107203255.GF24234@thunk.org>
	<CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
	<4EB85969.2010108@codemonkey.ws>
	<12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
	<20111108093225.GB32533@elte.hu>
Date: Wed, 9 Nov 2011 21:40:35 +0800
Message-ID: <CAM_iQpU4CsudDYxD=-tayEMmkKGP-hSPEsptC6sir7XDPJvzUA@mail.gmail.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 5:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> So i think you should seriously consider moving your projects *into*
> tools/ instead of trying to get other projects to move out ...
>
> You should at least *try* the unified model before criticising it -
> because currently you guys are preaching about sex while having sworn
> a life long celibacy ;-)
>

Ingo, this is making Linux another BSD... manage everything in a single
tree...

Also, what is your criteria for merging a user-space project into kernel tree?

Thanks.
