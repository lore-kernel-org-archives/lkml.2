Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0ELTBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:01:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0ELTBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:01:23 -0400
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
In-Reply-To: <20100512185111.GH21432@Krystal>
References: <20100512164650.GH5405@nowhere>
	 <1273683624.1626.127.camel@laptop> <20100512170734.GA15953@Krystal>
	 <1273686425.1626.142.camel@laptop> <20100512175305.GB32496@Krystal>
	 <1273687212.1626.147.camel@laptop> <20100512180438.GE15953@Krystal>
	 <1273687712.1626.151.camel@laptop> <20100512183704.GD21432@Krystal>
	 <1273690142.1626.158.camel@laptop>  <20100512185111.GH21432@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 21:01:18 +0200
Message-ID: <1273690878.1626.165.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 14:51 -0400, Mathieu Desnoyers wrote:
> 
> It makes it hard to use splice() or read() if you don't specify the buffer size
> at creation time. That alone seems like a pretty good argument for fixing the
> size before the mmap() call. 

Our read() doesn't actually provide the same data splice()/mmap() would.
But yeah, hence my proposal to create a separate syscall that creates
buffer objects.

