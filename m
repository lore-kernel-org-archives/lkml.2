Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab1KHLc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:32:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1KHLcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:32:55 -0500
Date: Tue, 8 Nov 2011 06:31:50 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Vince Weaver <vince@deater.net>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] perf ABI backwards and forwards compatibility
Message-ID: <20111108113150.GA13195@redhat.com>
References: <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org> <alpine.LFD.2.02.1111070838520.1823@tux.localdomain> <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <20111107175942.GA9395@elte.hu> <y0mpqh3og3v.fsf@fche.csb> <alpine.LFD.2.02.1111072204370.3082@tux.localdomain> <20111107203514.GG24234@thunk.org> <20111108102235.GA1241@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108102235.GA1241@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Nov 08, 2011 at 11:22:35AM +0100, Ingo Molnar wrote:

> [...]  These examples show *PICTURE PERFECT* forwards ABI
> compatibility, using the ancient perf tool on a bleeding edge
> kernel. [...]

Almost: they demonstrate that those parts of the ABI that these
particular perf commands rely on have been impressively compatible.
Do you have any sort of ABI coverage measurement, to see what
parts of the ABI these perf commands do not use?

- FChE
