Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab0KQNiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:38:52 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40933 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab0KQNiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:38:51 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20101117132404.GF27063@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117013700.GA3290@thunk.org>  <20101117132404.GF27063@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 14:38:48 +0100
Message-ID: <1290001128.2109.785.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:24 +0100, Ingo Molnar wrote:
> > What about the filtering and other general features/functionality of
> > ftrace?  Is the anticipation that this will be ported over to perf?
> > What about things like blktrace?
> 
> Yeah, i'd love to see all that available. Filtering is available already on the 
> kernel perf event side and could be added as an option. 

Except I utterly detest the existing filter code.. it runs _after_ we do
all the hard work and then makes us roll back when it decides we
shouldn't output after all.

But yes, it is functional.
