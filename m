Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1KHLgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:36:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33503 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab1KHLgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:36:16 -0500
Date: Tue, 8 Nov 2011 12:34:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Frank Ch. Eigler" <fche@redhat.com>, Vince Weaver <vince@deater.net>,
        Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] perf ABI backwards and forwards compatibility
Message-ID: <20111108113416.GA571@elte.hu>
References: <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <20111107175942.GA9395@elte.hu>
 <y0mpqh3og3v.fsf@fche.csb>
 <alpine.LFD.2.02.1111072204370.3082@tux.localdomain>
 <20111107203514.GG24234@thunk.org>
 <20111108102235.GA1241@elte.hu>
 <1320748366.2244.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320748366.2244.15.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> The ABI yes, the tool no, the tool very much relies on some newer 
> ABI parts. Supporting fallbacks isn't always possible/wanted.

Yeah, sure - and an older tool cannot possibly support newer features 
either.

Thanks,

	Ingo
