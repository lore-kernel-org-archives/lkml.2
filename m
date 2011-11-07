Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1KGUf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:35:29 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:54554 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab1KGUfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:35:25 -0500
Date: Mon, 7 Nov 2011 15:35:14 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to
 test kernels
Message-ID: <20111107203514.GG24234@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	"Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Vince Weaver <vince@deater.net>, Pekka Enberg <penberg@kernel.org>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Avi Kivity <avi@redhat.com>,
	"kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
	qemu-devel Developers <qemu-devel@nongnu.org>,
	Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <4EB6BEFA.6000303@codemonkey.ws>
 <20111106183132.GA4500@thunk.org>
 <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <20111107175942.GA9395@elte.hu>
 <y0mpqh3og3v.fsf@fche.csb>
 <alpine.LFD.2.02.1111072204370.3082@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111072204370.3082@tux.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 10:09:34PM +0200, Pekka Enberg wrote:
> 
> I guess for perf ABI, "perf test" is the closest thing to a
> specification so if your application is using something that's not
> covered by it, you might be in trouble.

I don't believe there's ever been any guarantee that "perf test" from
version N of the kernel will always work on a version N+M of the
kernel.  Perhaps I am wrong, though. If that is a guarantee that the
perf developers are willing to stand behind, or have already made, I
would love to be corrected and would be delighted to hear that in fact
there is a stable, backwards compatible perf ABI.

Regards,

						- Ted
