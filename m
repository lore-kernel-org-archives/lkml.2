Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1KHMU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:20:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38679 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1KHMUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:20:55 -0500
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
Date: Tue, 08 Nov 2011 13:20:25 +0100
In-Reply-To: <20111108121501.GA1022@elte.hu>
References: <20111106231953.GD4500@thunk.org>
	 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
	 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
	 <20111107175942.GA9395@elte.hu> <y0mpqh3og3v.fsf@fche.csb>
	 <alpine.LFD.2.02.1111072204370.3082@tux.localdomain>
	 <20111107203514.GG24234@thunk.org> <20111108102235.GA1241@elte.hu>
	 <20111108113150.GA13195@redhat.com>
	 <alpine.LFD.2.02.1111081336410.18135@tux.localdomain>
	 <20111108121501.GA1022@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320754825.11519.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 13:15 +0100, Ingo Molnar wrote:
> 
> The one notable thing that isnt being tested in a natural way is the 
> 'group of events' abstraction - which, ironically, has been added on 
> the perfmon guys' insistence. No app beyond the PAPI self-test makes 
> actual use of it though, which results in an obvious lack of testing. 

Also the self monitor stuff, perf-tool doesn't use that for obvious
reasons.
