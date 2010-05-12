Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0ELSAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:00:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0ELSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:00:18 -0400
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
In-Reply-To: <20100512175305.GB32496@Krystal>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
	 <20100511213625.GD5422@nowhere>
	 <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
	 <20100512144811.GA5405@nowhere>
	 <1273678596.27703.30.camel@gandalf.stny.rr.com>
	 <20100512164650.GH5405@nowhere> <1273683624.1626.127.camel@laptop>
	 <20100512170734.GA15953@Krystal> <1273686425.1626.142.camel@laptop>
	 <20100512175305.GB32496@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 20:00:12 +0200
Message-ID: <1273687212.1626.147.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 13:53 -0400, Mathieu Desnoyers wrote:
> 
> Would you be fine with an alternative implementation and API that support both
> mmap() and splice(), without any need to swap pages ? 

Sure, what did you have in mind?

You basically give you page to splice, never to see it again, you'd need
to fill that hole in your buffer again.

