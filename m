Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1KIKGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:06:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:56018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab1KIKGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:06:03 -0500
Subject: Re: [F.A.Q.] perf ABI backwards and forwards compatibility
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        "Frank Ch. Eigler" <fche@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
        Vince Weaver <vince@deater.net>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Wed, 09 Nov 2011 11:05:29 +0100
In-Reply-To: <20111108125932.GC1022@elte.hu>
References: <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
	 <20111107175942.GA9395@elte.hu> <y0mpqh3og3v.fsf@fche.csb>
	 <alpine.LFD.2.02.1111072204370.3082@tux.localdomain>
	 <20111107203514.GG24234@thunk.org> <20111108102235.GA1241@elte.hu>
	 <20111108113150.GA13195@redhat.com>
	 <alpine.LFD.2.02.1111081336410.18135@tux.localdomain>
	 <20111108121501.GA1022@elte.hu> <1320754825.11519.0.camel@twins>
	 <20111108125932.GC1022@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320833129.13360.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 13:59 +0100, Ingo Molnar wrote:
> 
> > Also the self monitor stuff, perf-tool doesn't use that for obvious 
> > reasons.
> 
> Indeed, and that's PAPI's strong point.
> 
> We could try to utilize it via some clever LD_PRELOAD trickery?

Wouldn't be really meaningful, a perf-test case that covers it would be
much saner.
