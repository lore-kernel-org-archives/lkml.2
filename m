Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879Ab0KQP7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:59:23 -0500
Received: from www.tglx.de ([62.245.132.106]:40586 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934771Ab0KQP7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:59:21 -0500
Date: Wed, 17 Nov 2010 16:58:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Avi Kivity <avi@redhat.com>
cc: Tom Zanussi <tzanussi@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
In-Reply-To: <4CE3FB0D.30902@redhat.com>
Message-ID: <alpine.LFD.2.00.1011171657400.2900@localhost6.localdomain6>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>  <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>  <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>  <1290003110.2109.822.camel@laptop>
 <1290003505.2109.833.camel@laptop>  <alpine.LFD.2.00.1011171529120.2900@localhost6.localdomain6> <1290008466.1921.21.camel@elnicho> <4CE3FB0D.30902@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Avi Kivity wrote:

> On 11/17/2010 05:41 PM, Tom Zanussi wrote:
> > 
> > > The only reason why these filters might make sense is to reduce the
> > > trace volume on system wide traces in production environments, but
> > > that's a completely different story. These scenarios can do with the
> > > dynamic tracepoint stuff and the custom filtering w/o putting the
> > > burden on the majority of users.
> > > 
> > Yeah, in my mind, the main point of the filters was to be a 'blunt
> > force' instrument preventing userspace from being overwhelmed by events.
> > The real filtering would happen in userspace with e.g. real scripting
> > languages.
> > 
> 
> Filtering is also useful for fine-grained perf events; this cannot be done in
> userspace.

Could you explain that a bit more detailed please ?

Thanks,

	tglx
 
